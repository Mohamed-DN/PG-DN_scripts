#!/usr/bin/env python3
"""Prove physical streaming replication in an isolated PostgreSQL 18 lab."""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
import subprocess
import sys
import time
import uuid

ROOT = Path(__file__).resolve().parents[2]
IMAGE = "docker.io/library/postgres:18-alpine"
PGDATA = "/var/lib/postgresql/18/docker"
SQL_CHECKS = tuple(sorted(
    path.relative_to(ROOT).as_posix()
    for area in ('replication', 'wal', 'backup')
    for path in (ROOT / 'scripts' / area).rglob('*.sql')
))


class ReplicationLab:
    def __init__(self, engine: str, version: str):
        self.engine = engine
        self.version = version
        self.suffix = uuid.uuid4().hex
        self.network = f"pgdn-repl-{self.suffix}"
        self.primary = f"pgdn-repl-{self.suffix}-primary"
        self.standby = f"pgdn-repl-{self.suffix}-standby"
        self.primary_volume = f"pgdn-repl-{self.suffix}-primary-data"
        self.standby_volume = f"pgdn-repl-{self.suffix}-standby-data"
        self.created_network = False
        self.created_volumes: list[str] = []
        self.created_containers: list[str] = []
        self.replay_paused = False
        self.report: dict = {
            "engine": engine,
            "postgres_major_requested": int(version),
            "image": IMAGE,
            "network_isolated": True,
            "host_ports_published": False,
            "checks": {},
            "scripts": [],
            "resources": {
                "network": self.network,
                "containers": [self.primary, self.standby],
                "volumes": [self.primary_volume, self.standby_volume],
            },
        }
        self.stage = "preflight"

    def owner_label(self, kind: str, name: str) -> str | None:
        field = "{{json .Config.Labels}}" if kind == "container" else "{{json .Labels}}"
        result = self.command(kind, "inspect", "--format", field, name,
                              check=False, timeout=8)
        if result.returncode:
            return None
        try:
            labels = json.loads(result.stdout.strip())
        except json.JSONDecodeError:
            return None
        return labels.get("pgdn.owner") if isinstance(labels, dict) else None

    @staticmethod
    def redact(text: str) -> str:
        text = re.sub(r"(?i)(password\s*=\s*)[^\s,;]+", r"\1[redacted]", text)
        return re.sub(r"(?i)(postgres(?:ql)?://)[^/@\s]+@", r"\1[redacted]@", text)

    def command(self, *args: str, input: str | None = None, check: bool = True,
                timeout: int = 60) -> subprocess.CompletedProcess:
        result = subprocess.run(
            [self.engine, *args], input=input, text=True, encoding="utf-8",
            errors="replace", capture_output=True, timeout=timeout, shell=False,
        )
        if check and result.returncode:
            detail = (result.stderr or result.stdout).strip()
            raise RuntimeError(f"{args[0]} failed (exit {result.returncode}): {self.redact(detail[-1800:])}")
        return result

    def assert_names_free(self) -> None:
        for name in (self.primary, self.standby):
            result = self.command("container", "inspect", name, check=False)
            if result.returncode == 0:
                raise RuntimeError(f"Refusing to touch pre-existing container {name}")
        for name in (self.network,):
            result = self.command("network", "inspect", name, check=False)
            if result.returncode == 0:
                raise RuntimeError(f"Refusing to touch pre-existing network {name}")
        for name in (self.primary_volume, self.standby_volume):
            result = self.command("volume", "inspect", name, check=False)
            if result.returncode == 0:
                raise RuntimeError(f"Refusing to touch pre-existing volume {name}")

    def create(self) -> None:
        self.assert_names_free()
        self.command(
            "network", "create", "--internal", "--label", "pgdn.disposable=true",
            "--label", f"pgdn.owner={self.suffix}", self.network,
        )
        self.created_network = True
        for volume in (self.primary_volume, self.standby_volume):
            self.command("volume", "create", "--label", "pgdn.disposable=true",
                         "--label", f"pgdn.owner={self.suffix}", volume)
            self.created_volumes.append(volume)

        common = [
            "run", "-d", "--network", self.network,
            "--label", "pgdn.disposable=true", "--label", f"pgdn.owner={self.suffix}",
            "-e", "POSTGRES_HOST_AUTH_METHOD=trust",
            "-e", f"PGDATA={PGDATA}",
            "-v",
        ]
        self.command(
            *common, f"{self.primary_volume}:/var/lib/postgresql",
            "--name", self.primary, "--network-alias", "primary", IMAGE,
            "-c", "wal_level=replica", "-c", "max_wal_senders=5",
            "-c", "max_replication_slots=5", "-c", "hot_standby=on",
        )
        self.created_containers.append(self.primary)

        # Hold an empty, disposable volume open while pg_basebackup populates it.
        self.command(
            "run", "-d", "--network", self.network, "--label", "pgdn.disposable=true",
            "--label", f"pgdn.owner={self.suffix}",
            "--name", self.standby, "--network-alias", "standby",
            "-e", f"PGDATA={PGDATA}", "-v", f"{self.standby_volume}:/var/lib/postgresql",
            IMAGE, "sleep", "3600",
        )
        self.created_containers.append(self.standby)

    def exec(self, container: str, *args: str, check: bool = True,
             timeout: int = 60, input: str | None = None,
             user: str | None = None) -> subprocess.CompletedProcess:
        prefix = ["exec", "-i"]
        if user:
            prefix.extend(["--user", user])
        return self.command(*prefix, container, *args, input=input,
                            check=check, timeout=timeout)

    def psql(self, container: str, sql: str, database: str = "postgres",
             check: bool = True, timeout: int = 30) -> str:
        result = self.exec(
            container, "psql", "-X", "-w", "-v", "ON_ERROR_STOP=1",
            "-U", "postgres", "-d", database, "-At", check=check,
            timeout=timeout, input=sql,
        )
        return result.stdout.strip()

    def wait_for(self, description: str, predicate, timeout: float = 45.0,
                 interval: float = 0.25):
        deadline = time.monotonic() + timeout
        last = "not yet observed"
        while time.monotonic() < deadline:
            try:
                value = predicate()
                last = str(value)
                if value:
                    return value
            except (RuntimeError, subprocess.TimeoutExpired):
                pass
            time.sleep(interval)
        raise RuntimeError(f"Timed out waiting for {description}; last state: {last}")

    def wait_ready(self, container: str, label: str) -> None:
        deadline = time.monotonic() + 60
        while time.monotonic() < deadline:
            ready = self.exec(container, "pg_isready", "-U", "postgres", check=False,
                              timeout=8)
            if ready.returncode == 0:
                init_done = self.exec(
                    container, "sh", "-c", 'test "$(cat /proc/1/comm)" = postgres',
                    check=False, timeout=8,
                )
                if init_done.returncode == 0:
                    return
            state = self.command("container", "inspect", "--format", "{{.State.Status}}",
                                 container, check=False, timeout=8).stdout.strip()
            if state in {"exited", "dead", "removing"}:
                state_detail = self.command(
                    "container", "inspect", "--format", "{{json .State}}", container,
                    check=False, timeout=8,
                )
                log_result = self.command("logs", "--tail", "35", container,
                                          check=False, timeout=8)
                logs = log_result.stdout + log_result.stderr
                raise RuntimeError(
                    f"{label} container stopped before readiness ({state}): "
                    f"state={state_detail.stdout.strip()} "
                    f"{self.redact(logs)[-2500:]}"
                )
            time.sleep(0.25)
        state_detail = self.command(
            "container", "inspect", "--format", "{{json .State}}", container,
            check=False, timeout=8,
        )
        log_result = self.command("logs", "--tail", "35", container,
                                  check=False, timeout=8)
        logs = log_result.stdout + log_result.stderr
        raise RuntimeError(
            f"Timed out waiting for {label} PostgreSQL readiness; "
            f"state={state_detail.stdout.strip()} {self.redact(logs)[-2500:]}"
        )

    def run(self) -> dict:
        self.stage = "create-isolated-resources"
        self.create()
        self.stage = "primary-readiness"
        self.wait_ready(self.primary, "primary")
        self.report["server_version"] = self.psql(self.primary, "SHOW server_version;")
        self.report["image_id"] = self.command(
            "image", "inspect", "--format", "{{.Id}}", IMAGE,
        ).stdout.strip()

        self.stage = "replication-role-and-slot"
        self.psql(self.primary, "CREATE ROLE pgdn_repl LOGIN REPLICATION;")
        self.psql(self.primary, "SELECT pg_create_physical_replication_slot('pgdn_repl_slot');")
        self.exec(
            self.primary, "sh", "-c",
            f"printf '%s\\n' 'host replication pgdn_repl all trust' >> {PGDATA}/pg_hba.conf",
        )
        if self.psql(self.primary, "SELECT pg_reload_conf();") != "t":
            raise RuntimeError("Could not reload the isolated replication HBA rule")
        self.report["checks"]["replication_trust_scoped_to_internal_lab"] = True
        self.stage = "basebackup-and-verify"
        self.command(
            "exec", "-i", "--user", "postgres", self.standby, "pg_basebackup", "-w", "-h", "primary",
            "-p", "5432", "-U", "pgdn_repl", "-D", PGDATA,
            "-X", "stream", "-R", "-c", "fast", "-S", "pgdn_repl_slot",
            "--manifest-checksums=SHA256", timeout=90,
        )
        verify = self.exec(
            self.standby, "pg_verifybackup", PGDATA, timeout=45, user="postgres",
        )
        self.report["checks"]["pg_verifybackup"] = "passed"
        self.report["backup_verification"] = verify.stdout.strip() or "manifest verified"

        self.stage = "standby-container-replacement"
        if self.owner_label("container", self.standby) != self.suffix:
            raise RuntimeError("Refusing to replace standby container without this lab's owner label")
        self.command("rm", "-f", self.standby)
        self.created_containers.remove(self.standby)
        self.command(
            "run", "-d", "--network", self.network,
            "--label", "pgdn.disposable=true", "--label", f"pgdn.owner={self.suffix}",
            "--name", self.standby,
            "--network-alias", "standby", "-e", f"PGDATA={PGDATA}",
            "-v", f"{self.standby_volume}:/var/lib/postgresql", IMAGE,
            "-c", "hot_standby=on",
        )
        self.created_containers.append(self.standby)
        self.stage = "standby-startup"
        self.wait_ready(self.standby, "standby")
        recovery = self.wait_for(
            "standby recovery state",
            lambda: (lambda value: value if value == "t" else "")(
                self.psql(self.standby, "SELECT pg_is_in_recovery();")
            ),
        )
        self.report["checks"]["standby_in_recovery"] = recovery == "t"
        stream = self.wait_for(
            "active streaming sender",
            lambda: (lambda value: value if "streaming" in value.splitlines() else "")(
                self.psql(self.primary,
                          "SELECT state FROM pg_stat_replication WHERE application_name <> '';")
            ),
        )
        if "streaming" not in stream.splitlines():
            raise RuntimeError(f"Primary sender is not streaming: {stream}")
        self.report["checks"]["streaming_active"] = True

        self.stage = "fixture-initial-replication"
        self.psql(self.primary, """
            CREATE SCHEMA pgdn_replication;
            CREATE TABLE pgdn_replication.fixture (
                id integer PRIMARY KEY,
                payload text NOT NULL
            );
            INSERT INTO pgdn_replication.fixture
                SELECT i, repeat(md5(i::text), 8) FROM generate_series(1, 20) AS i;
        """)
        baseline = self.wait_for(
            "initial fixture rows on standby",
            lambda: (lambda value: value if value == "20" else "")(
                self.psql(self.standby, "SELECT count(*) FROM pgdn_replication.fixture;")
            ),
        )
        self.report["fixture_rows_initial"] = int(baseline)
        self.report["checks"]["fixture_replicated_initially"] = True

        self.stage = "pause-lag-resume"
        self.psql(self.standby, "SELECT pg_wal_replay_pause();")
        self.replay_paused = True
        self.wait_for(
            "standby replay pause",
            lambda: self.psql(self.standby, "SELECT pg_is_wal_replay_paused();") == "t",
        )
        self.psql(self.primary, """
            INSERT INTO pgdn_replication.fixture
            SELECT i, repeat(md5(i::text), 16) FROM generate_series(21, 120) AS i;
        """)
        lag_value = self.wait_for(
            "received-but-not-replayed WAL bytes above zero",
            lambda: (lambda value: value if value.isdigit() and int(value) > 0 else "")(
                self.psql(self.standby, """
                    SELECT coalesce(pg_wal_lsn_diff(pg_last_wal_receive_lsn(),
                                                    pg_last_wal_replay_lsn()), 0)::bigint;
                """)
            ),
            timeout=45,
        )
        stale_count = self.psql(
            self.standby, "SELECT count(*) FROM pgdn_replication.fixture;",
        )
        if stale_count != "20":
            raise RuntimeError(f"Replay paused but standby fixture changed: {stale_count}")
        self.report["checks"]["paused_replay_lag_positive"] = True
        self.report["paused_lag_bytes"] = int(lag_value)
        self.report["checks"]["paused_standby_remained_at_baseline"] = True
        self.report["fixture_rows_while_paused"] = int(stale_count)

        self.stage = "diagnostic-sql-on-standby"
        for relative in SQL_CHECKS:
            path = ROOT / relative
            result = self.exec(
                self.standby, "psql", "-X", "-w", "-v", "ON_ERROR_STOP=1",
                "-U", "postgres", "-d", "postgres", "-At", input=path.read_text(encoding="utf-8"),
                check=False, timeout=30,
            )
            self.report["scripts"].append({
                "path": relative,
                "status": "passed" if result.returncode == 0 else "failed",
                "exit_code": result.returncode,
                "output": result.stdout.strip()[-1200:],
                "error": result.stderr.strip()[-1800:],
            })

        self.stage = "resume-and-convergence"
        self.psql(self.standby, "SELECT pg_wal_replay_resume();")
        self.replay_paused = False
        self.wait_for(
            "standby replay resume",
            lambda: self.psql(self.standby, "SELECT NOT pg_is_wal_replay_paused();") == "t",
        )
        final_count = self.wait_for(
            "all fixture rows converged on standby",
            lambda: (lambda value: value if value == "120" else "")(
                self.psql(self.standby, "SELECT count(*) FROM pgdn_replication.fixture;")
            ),
            timeout=45,
        )
        self.report["fixture_rows_primary_final"] = 120
        self.report["fixture_rows_standby_final"] = int(final_count)
        self.report["checks"]["replication_converged"] = True
        self.report["checks"]["streaming_active_after_resume"] = (
            "streaming" in self.psql(
                self.primary,
                "SELECT state FROM pg_stat_replication WHERE application_name <> '';",
            ).splitlines()
        )
        if not self.report["checks"]["streaming_active_after_resume"]:
            raise RuntimeError("Streaming sender did not remain active after replay resume")
        if any(row["status"] != "passed" for row in self.report["scripts"]):
            failed = [row["path"] for row in self.report["scripts"] if row["status"] != "passed"]
            self.report["checks"]["diagnostic_scripts_all_passed"] = False
            raise RuntimeError("Diagnostic SQL errors: " + ", ".join(failed))
        self.report["checks"]["diagnostic_scripts_all_passed"] = True
        self.report["checks"]["no_pitr_claim"] = True
        return self.report

    def close(self) -> list[str]:
        errors = []
        if self.replay_paused:
            try:
                if self.owner_label("container", self.standby) == self.suffix:
                    self.psql(self.standby, "SELECT pg_wal_replay_resume();", check=False, timeout=8)
            except Exception as exc:
                errors.append(f"standby replay resume before cleanup: {exc}")
            self.replay_paused = False
        for container in (self.standby, self.primary):
            try:
                present = self.command("container", "inspect", container,
                                       check=False, timeout=8).returncode == 0
                if not present:
                    continue
                if self.owner_label("container", container) != self.suffix:
                    errors.append(f"container {container}: cleanup refused; owner label mismatch")
                    continue
                result = self.command("rm", "-f", container, check=False, timeout=20)
                if result.returncode:
                    errors.append(f"container {container}: {self.redact(result.stderr[-1000:])}")
            except Exception as exc:  # Cleanup continues only for the exact resources created here.
                errors.append(f"container {container}: {exc}")
        for volume in (self.standby_volume, self.primary_volume):
            try:
                present = self.command("volume", "inspect", volume,
                                       check=False, timeout=8).returncode == 0
                if not present:
                    continue
                if self.owner_label("volume", volume) != self.suffix:
                    errors.append(f"volume {volume}: cleanup refused; owner label mismatch")
                    continue
                result = self.command("volume", "rm", "-f", volume, check=False, timeout=20)
                if result.returncode:
                    errors.append(f"volume {volume}: {self.redact(result.stderr[-1000:])}")
            except Exception as exc:
                errors.append(f"volume {volume}: {exc}")
        try:
            present = self.command("network", "inspect", self.network,
                                   check=False, timeout=8).returncode == 0
            if present and self.owner_label("network", self.network) != self.suffix:
                errors.append(f"network {self.network}: cleanup refused; owner label mismatch")
            elif present:
                result = self.command("network", "rm", self.network, check=False, timeout=20)
                if result.returncode:
                    errors.append(f"network {self.network}: {self.redact(result.stderr[-1000:])}")
        except Exception as exc:
            errors.append(f"network {self.network}: {exc}")
        return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--engine", choices=("podman", "docker"), default="podman")
    parser.add_argument("--version", choices=("18",), default="18")
    parser.add_argument("--output", default="test-results/replication.json")
    args = parser.parse_args()
    lab = ReplicationLab(args.engine, args.version)
    report = lab.report
    report["status"] = "failed"
    print(f"PostgreSQL {args.version}: isolated physical replication lab starting", flush=True)
    try:
        lab.run()
        report["status"] = "passed"
        print("PostgreSQL 18: base backup, streaming, pause/lag/resume/convergence and diagnostic SQL passed", flush=True)
    except Exception as exc:
        report["stage"] = lab.stage
        report["error"] = lab.redact(str(exc))
        print(f"PostgreSQL 18: FAIL [{lab.stage}] {report['error']}", flush=True)
    finally:
        report["cleanup_errors"] = lab.close()
        report["cleanup"] = "passed" if not report["cleanup_errors"] else "failed"
        report["pitr_proven"] = False
        destination = ROOT / args.output
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    return 0 if report["status"] == "passed" and report["cleanup"] == "passed" else 1


if __name__ == "__main__":
    sys.exit(main())

# Orion-Configuration

## 1. Project Summary

Orion-Configuration is the on-device WebConfig product for Orion's ST STM32MP1 platform.

- A Rust workspace contains `webconfig-engine`, a synchronous and hardware-testable configuration core, and `webconfigd`, its asynchronous Axum HTTP layer.
- The daemon uses Tokio current-thread, rustls TLS, a no-build vanilla JavaScript frontend, and one non-root service.
- Board capabilities come from `board-manifests/orion.json` or the generic YAML fallback.

The engine owns configuration storage, schema parsing and validation, board manifests, system appliers, encrypted backup and restore, audit logging, users, and monitoring reads from a Linux sysroot.

- The HTTP layer adds routing, authentication, CSRF, SSE events, and the bridge to the engine.
- Frontend pages cover system, networking, services, updates, monitoring, logs, alerts, cloud, time, display, camera, serial, LEDs, security, backup, and MCU settings.
- Network changes support provisional apply and rollback confirmation; updates use RAUC slots and staged bundles.

The repository also ships JSON schemas, board data, systemd/polkit assets, and the `meta-webconfig` Yocto layer.

- The documented gate is `make build && make test && make lint`.
- Fake-sysroot tests need no hardware.
- This summary reports source and tests, not deployed TLS, RAUC, or real-device verification.

## 2. Feature Status

| # | Name / Description | Implemented? | Test Coverage? | Manual Test |
|---:|---|---|---|---|
| 1 | Rust configuration engine and file-backed store | Implemented | Partial: engine tests present | [ ] Manual verification required |
| 2 | JSON/YAML board manifest loading | Implemented | Partial: parse checks documented | [ ] Manual verification required |
| 3 | JSON-Schema settings and frontend forms | Implemented | Partial: schema and engine tests | [ ] Manual verification required |
| 4 | Axum daemon with TLS/rustls and Tokio | Implemented | Partial: in-crate HTTP tests | [ ] Manual verification required |
| 5 | Session authentication and CSRF | Implemented | Partial: HTTP coverage present | [ ] Manual verification required |
| 6 | Provisional network apply and rollback | Implemented | Partial: real reconnect unverified | [ ] Manual verification required |
| 7 | Monitoring vitals and SSE events | Implemented | Partial: fake-sysroot coverage | [ ] Manual verification required |
| 8 | Encrypted backup/restore and audit log | Implemented | Partial: backup unit tests | [ ] Manual verification required |
| 9 | RAUC updates and MCU actions | Partial | Unknown: real backends unverified | [ ] Manual verification required |
| 10 | `meta-webconfig` Yocto packaging | Implemented | Unknown: image build not run here | [ ] Manual verification required |

## 3. Build and Test

```bash
make build
make test
make lint
```

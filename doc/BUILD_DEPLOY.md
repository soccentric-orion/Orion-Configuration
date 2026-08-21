# Orion-Configuration Build and Deployment

## 1. Purpose and Scope
Orion-Configuration is the Rust Cargo workspace for the `webconfigd` on-device configuration daemon and the reusable `webconfig-engine`. The root Makefile is the supported entry point. It pins Rust 1.97.1 with rustfmt, clippy, and x86_64, aarch64, and armv7 targets; the release profile uses size optimization, LTO, one codegen unit, aborting panics, and symbol stripping.

## 2. Prerequisites
- `rustup`, network access for the pinned toolchain/dependencies, and a POSIX shell.
- Rust targets/components from `rust-toolchain.toml`; run `make toolchain` for the exact setup.
- Cargo and standard build tools. Cross builds additionally need linkers/toolchains for the three target triples.
- A systemd/Linux device and its real `/proc`, `/sys`, D-Bus, TLS, and storage paths for hardware validation.

## 3. Setup
```bash
make toolchain
make help
```
`make toolchain` installs rustup if missing, installs channel `1.97.1` with rustfmt/clippy, and adds all declared targets. It downloads from `static.rust-lang.org` and is not suitable for a network-restricted environment.

## 4. Build and Compile
```bash
make build
make release
make cross
```
`build` compiles the workspace for the host. `release` uses the pinned size-focused release profile. `cross` builds release artifacts for x86_64, aarch64, and armv7; it requires usable cross linkers and target libraries. The Cargo workspace contains `crates/webconfig-engine` and `crates/webconfigd`.

## 5. Test and Lint
```bash
make test
make lint
make fmt
make check
```
Tests use `cargo test --workspace --all-targets` with fake sysroot paths and do not require hardware. `lint` runs clippy with `-D warnings` and `cargo fmt --check`; `fmt` edits files in place. `check` is the aggregate build, test, and lint gate.

## 6. Packaging and Artifacts
```bash
make vendor
make release-artifacts
```
`vendor` regenerates the versioned offline Cargo vendor tree and should be rerun after dependency changes. `release-artifacts` invokes `tools/release-artifacts.sh` to package the source and vendor tarballs used by `meta-webconfig` and print SHA-256 checksums. The normal Cargo outputs are under `target/`; Yocto recipe integration is under `meta-webconfig/`.

## 7. Deploy, Install, and Run
```bash
make run-mock
WEBCONFIG_PORT=9443 make run
make stop
```
`run-mock` uses a temporary fake sysroot, zero vitals, mock backends, and temporary state. `run` uses the real host root, live `/proc`/`/sys`, real systemd/update backends, and persistent development state in `./data`; it defaults to TCP port 8443 via `WEBCONFIG_PORT`. The Makefile has no remote deployment target: production installation belongs in the Yocto `meta-webconfig` recipes/image and requires target-specific service, TLS, data, and permissions setup.

## 8. Cleanup
```bash
make clean
rm -rf data
```
`make clean` runs `cargo clean` and removes `target/`. Removing `data` resets the development daemon's first-boot state and must not be done to production state without an explicit recovery decision.

## 9. Hardware, Cloud, and Manual Verification Caveats
The fake-sysroot tests prove engine and HTTP behavior without hardware, not systemd, D-Bus, real `/sys`, TLS provisioning, or update execution. Validate the built Yocto integration on an STM32MP1 target, including first-boot admin setup, certificate handling, port exposure, persistence, and rollback/update behavior. No cloud credentials are used by these Make targets; any external artifact repository or device access is an operational prerequisite outside this Makefile.

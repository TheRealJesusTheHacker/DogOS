# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Decision execution wave, 2026-10-21 (static verification only — no
  ISO built; live-build cannot run on the audit VM):
  - D-13 live-boot credentials: `dogos-live-password` + systemd unit
    randomize the live user's password on every live boot and display
    it on the login screen (`/etc/issue`, LightDM greeter full name,
    tmpfs copy); failure locks the live account — no known-password
    fallback. Policy recorded in `dogos-livebuild/README.md`.
  - D-8 Firefox sandbox: `/usr/local/bin/firefox-esr-bwrap` Bubblewrap
    wrapper + `firefox-esr.desktop` override in `includes.chroot`;
    the hardening hook's build note is resolved. Sandbox
    validation rides the first ISO build (D-3).
  - D-6: `dogos-extras` packaging queue trimmed 21 → 12, with the
    per-entry kept/cut basis recorded in `dogos-extras/README.md`.
  - D-11: Calamares slideshow defaults accepted for the first ISO
    (note resolved in `branding.desc`; branding URLs untouched).
  - D-7 / D-12 recorded in the README roadmap: weekly automated
    build + boot smoke ADOPTED once the first ISO exists;
    pentest-copilot prompt pack KEPT, authored once the ISO line
    is live.

### Fixed

- Fleet sweep #4, 2026-10-23: the staged `dogos-scripts_0.2.0_all.deb`
  in `dogos-extras/staging/` still shipped the pre-sweep-#3
  `dogos-engage` (per-port, non-atomic applies) and `dogos-hostname`
  (success claimed on failure), even though the READMEs described the
  package as matching the hardened in-tree scripts. The `.deb` was
  repacked from the current `includes.chroot` scripts and all five
  payloads byte-verified against the tree. Version unchanged at 0.2.0.
- Bug hunt sweep #3, 2026-10-21 (stubbed-command probes; no build on
  the audit VM — live-build cannot run there):
  - `dogos-engage open` applied ports one `nft add element` call per
    port, so a failure mid-apply left the earlier ports open while the
    command reported an error — a half-applied firewall exception. All
    validated ports now go in a single atomic `nft` call: failure
    applies none of them.
  - `dogos-hostname` only fell back to `hostname` when `hostnamectl`
    was *missing* — a present-but-failing `hostnamectl` meant the
    random name was never set — and both attempts were `|| true`, so
    total failure still printed the new name and exited 0. The
    fallback now fires on failure too, and total failure warns on
    stderr and exits 1 without claiming the name.

## [0.1.1] - 2026-10-11

### Added

- MIT license
- Kali-style expanded README (full feature rundown, build instructions, roadmap)
- CI gate: `bash -n` syntax check + shellcheck (warning severity) over every
  shell script on push/PR to main, with SHA-pinned actions
- `SECURITY.md`, issue templates (bug report, feature request), PR template

## [0.1.0] - 2026-10-11 — "Doberman" (first public prerelease)

### Added

- DogOS project source: Debian testing (forky) live-build scaffold for a
  security/pentest distro, MATE on X11, Calamares installer
- Release codename scheme: dog breeds, starting with Doberman
- Full + lite flavors: full ships all fifteen Kali metapackages (~10–11 GB
  ISO); lite ships `kali-tools-top10` plus verified additions (~4–5 GB ISO)
- Tool expansion: ffuf, gobuster, chisel, bloodhound, hcxtools, hcxdumptool,
  ghidra, valgrind, slowloris, dnstwist, sherlock, dnscrypt-proxy,
  llama.cpp, beef-xss (in lite); full-only dev layer
- DogOS helper CLI as first native package: `dogos-scripts` 0.2.0
  (dogos-engage, dogos-ghost, dogos-ai-setup, dogos-leaktest, dogos-hostname)
- Anonymity stack: Tor, I2P, obfs4, dnscrypt-proxy, privoxy; Ghost mode
  transparent Tor routing with captive-portal hatch and leak verification
- Amnesiac live mode: `toram` boot entry, always-on MAC randomization,
  live-boot hostname randomization
- Hardening defaults: nftables default-deny incoming, AppArmor, Bubblewrap,
  no listening services, password-required sudo, LUKS in installer
- Local-AI default: llama.cpp in-image, Ollama on demand, cloud APIs opt-in
- OSINT mega-pack: installable tools, 30-service bookmark pack, starter
  wordlists, GHDB dork starters, API-key template, SecLists fetcher
- `dogos-extras` signed APT repo scaffold (reprepro) with import/export tooling
- Design spec, adversarial security review, OSINT toolkit inventory
- Animated Plymouth boot splash, DogOS wallpaper, branded Calamares

### Fixed

- Bug hunt (2026-10-11): hardened `dogos-*` helpers, fixed the
  dogos-hostname systemd unit, amnesiac `toram` GRUB injection
- Bug hunt (2026-10-11): hooks path in livebuild README (flat
  `config/hooks`, no `live/` subdir); dropped stale LOIC fork reference
  from dogos-extras README; client apt config marked pending (no
  placeholder source — a dead `URIs:` entry would break `apt update`);
  design spec corrected — first native package is `dogos-scripts` 0.2.0,
  not 0.1.0

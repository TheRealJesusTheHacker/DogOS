# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

# dogos-extras — DogOS signed APT repository

Holds everything DogOS needs that Debian doesn't ship: repackaged pip
tools (hash-pinned, vendored wheels), manually built tools, and the
`dogos-*` helper scripts as proper packages. (LOIC was audited and
REJECTED 2026-10-10 — no maintained port exists; see design spec.)

## One-time setup (Skyler)
1. Generate the **offline master signing key** (spec section 10: release integrity):
   `gpg --full-generate-key` on an air-gapped machine. Subkey for day-to-day signing.
2. Put the key ID in `conf/distributions` (`SignWith:`).
3. `sudo apt install reprepro`
4. Serve `dists/` + `pool/` over HTTPS (any static host).

## Importing a package
`./scripts/import-deb.sh /path/to/foo_1.0_amd64.deb`

## Publishing the key
`./scripts/export-key.sh` → `dogos-extras.asc`

## Client config (TODO: ships in the DogOS image via live-build includes
once the repo URL and signing key exist — do NOT add a placeholder source
before then; a dead `URIs:` entry breaks `apt update` on every boot)
```
# /etc/apt/sources.list.d/dogos-extras.sources
Types: deb
URIs: https://repo.dogos.example/
Suites: dogos
Components: main
Signed-By: /usr/share/keyrings/dogos-extras.gpg
```

## Packaging status
- BUILT 2026-10-10: dogos-scripts 0.2.0 (`staging/`) — engage, ghost, ai-setup, leaktest, hostname
- REBUILT 2026-10-13 (security audit): the staging `.deb` was repacked from
  the current in-tree scripts — the original artifact predated the Oct 11
  ghost/engage/ai-setup hardening (atomic ghost-rules publish, portal
  marker, checksum-pinned Ollama installer). Version unchanged at 0.2.0;
  the repo has never been published (SignWith is still a placeholder).
- REJECTED 2026-10-10: LOIC — audit found no maintained port; see design spec
- Queued (pip → vendored, hash-pinned): holehe, maigret, snscrape, shodan, social-analyzer, toutatis, whisper, sgpt (Shell-GPT), aichat
- Queued (manual builds): phoneinfoga, onionsearch, blackbird, ghunt, ligolo, cutter
- Queued (upstream debs, mirrored+verified): feather-wallet, yggdrasil, retroshare, gh (GitHub CLI), android-tools-adb/fastboot, bless
- RESOLVED via APT 2026-10-10: sherlock, photon, slowloris, dnstwist, instaloader, finalrecon, ffuf, gobuster, chisel, bloodhound, hcxtools, hcxdumptool, ghidra, valgrind, dnscrypt-proxy, privoxy, llama.cpp (all in dogos-*.list.chroot)

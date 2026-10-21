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
- Queued (pip → vendored, hash-pinned): holehe, maigret, snscrape, shodan, sgpt (Shell-GPT), aichat
- Queued (manual builds): phoneinfoga, blackbird, ghunt
- Queued (upstream debs, mirrored+verified): feather-wallet, yggdrasil, retroshare
- RESOLVED via APT 2026-10-10: sherlock, photon, slowloris, dnstwist, instaloader, finalrecon, ffuf, gobuster, chisel, bloodhound, hcxtools, hcxdumptool, ghidra, valgrind, dnscrypt-proxy, privoxy, llama.cpp (all in dogos-*.list.chroot)

## Packaging queue trim — 2026-10-21 (D-6)

Decision (2026-10-21): trim the queue to the tools the ISO actually
calls BEFORE packaging anything. Packaging itself still binds after
the owner-hands repo setup (D-5) lands — nothing was packaged in this
trim and no tooling or scripts were removed; this is a queue-record
trim only. Basis rule: a KEEP is named as dogos-extras-delivered in a
live-build package list (`dogos-livebuild/config/package-lists/`) or
invoked by content the ISO ships; a CUT appears nowhere in the
live-build tree outside this queue and its root-README summary.

Kept (12):

- holehe — named in `dogos-osint.list.chroot` (pip via dogos-extras)
- maigret — named in `dogos-osint.list.chroot` (pip via dogos-extras)
- snscrape — named in `dogos-osint.list.chroot` (pip via dogos-extras)
- shodan — named in `dogos-osint.list.chroot`; the ISO also ships its API-key slot (`keys.env.template`) and bookmark-pack entry
- sgpt (Shell-GPT) — named in `dogos-ai.list.chroot` (pip via dogos-extras)
- aichat — named in `dogos-ai.list.chroot` and in the shipped `dogos-ai-setup` opt-in notice
- phoneinfoga — named in `dogos-osint.list.chroot` (manual via dogos-extras)
- blackbird — named in `dogos-osint.list.chroot` (manual via dogos-extras)
- ghunt — named in `dogos-osint.list.chroot` (manual via dogos-extras)
- feather-wallet — named in `dogos-anonymity.list.chroot` (manual via dogos-extras)
- yggdrasil — named in `dogos-anonymity.list.chroot` (packaging-verify line; extras is the tree's route for non-Debian tools)
- retroshare — named in `dogos-anonymity.list.chroot` (packaging-verify line; extras is the tree's route for non-Debian tools)

Cut (9):

- social-analyzer — no package list or shipped ISO content names it
- toutatis — no package list or shipped ISO content names it
- whisper — no package list or shipped ISO content names it
- onionsearch — no package-list/shipped reference (the OSINT list's manual entry is onionscan, a different tool)
- ligolo — no reference; the tunnelling slot is already filled by chisel via APT
- cutter — no reference; the reverse-engineering slot is already filled by ghidra via the Kali lists
- gh (GitHub CLI) — no package list or script invokes it; the dev layer ships git + git-lfs via APT
- android-tools-adb/fastboot — not named in any package list or shipped content
- bless — no reference; the hex-editing slot is already filled by hexedit in `dogos-dev.list.chroot`

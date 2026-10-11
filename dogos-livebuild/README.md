# DogOS live-build tree

Scaffold for building the DogOS live ISO. Maps 1:1 to `../design-spec.md`.

## Layout
- `auto/config` — live-build entrypoint (`./auto/config && sudo lb build`)
- `config/package-lists/` — APT package lists per layer (`.list.chroot`)
- `config/archives/` — extra APT sources (Kali repo — see README there)
- `config/hooks/` — hooks, flat per live-build 3.x (`*.chroot`, `*.binary`:
  branding, hardening, scripts, amnesiac boot entry)
- `config/includes.chroot/` — files overlaid into the live system
  (`/usr/local/bin/dogos-*` helpers, nftables base rules, sysctls,
  wallpaper, OSINT resource dirs)

## Build prerequisites
- Debian host (or container) with `live-build` installed
- ~20 GB free disk; root for `lb build`
- Verify the testing codename in `auto/config` (forky at time of writing)

## Flavors
- `./build.sh full` (default) — kitchen sink, ~10–11 GB ISO
- `./build.sh lite` — top10 + DogOS layers, ~4–5 GB ISO
- The script assembles the flavor into a fresh `mktemp`'d
  `/tmp/dogos-build-XXXXXXXX/` dir (unique per run — a fixed dir would be a
  local symlink-plant/TOCTOU target), overlays `flavors/lite/` for lite,
  and runs `auto/config`. It prints the build dir; remove it yourself
  after the ISO is built.
  Then `sudo lb build` inside the build dir, and rename the ISO
  afterwards (3.x dropped --image-name): `mv live-image-*.iso dogos-<flavor>.iso`

## Live-build 3.x notes (validated 2026-10-10 against 3.0~a57)
- Hooks are flat: `config/hooks/*.chroot`, `config/hooks/*.binary`
  (no `live/` subdir, no `.hook` infix — the old layout is silently ignored)
- `auto/config` MUST call `lb config noauto ...` with `noauto` first, or
  lb_config re-executes `./auto/config "$@"` and fork-bombs
- `--bootloader` is singular (`grub` covers BIOS+UEFI on iso-hybrid)

## TODO before first real build
1. DONE (2026-10-10): Kali archive wired — kali-rolling source + official 2025.3
   keyring, fingerprints verified against Kali's published values
   (see `config/archives/README.md`)
2. DONE (2026-10-10): package names verified against the live Debian
   forky / Kali rolling archive indices. Re-verify with `apt-cache policy`
   before building anyway — a rolling base moves.
3. `dogos-extras` repo: scaffold + first package (dogos-scripts 0.2.0) done —
   LOIC rejected post-audit; now: repackaged pip tools (hash-pinned, vendored
   wheels), modern stress-tool candidates (T50, Anevicon — slowloris already
   resolves via APT)
4. DONE (2026-10-10): Plymouth animated splash — 8 pulsing Doberman frames +
   script theme with LUKS passphrase prompt handling
5. DONE (2026-10-10): Ghost mode nftables redirect rules (TCP->TransPort,
   DNS->DNSPort, Tor UID exclusion) + captive-portal hatch + per-app routing
6. Measure ISO size; split `dogos-lite` only if live-boot suffers
7. GPG-sign the ISO; publish fingerprint out-of-band
8. DONE (2026-10-10): amnesiac mechanics (MAC randomization, live-boot hostname
   service), dogos-leaktest, OSINT bookmark pack (30 services), MATE menu
   categories, dogos-scripts 0.2.0
9. DONE (2026-10-10): `toram` amnesiac boot-menu entry (binary hook clones the
   default syslinux/GRUB entries, defensive); wordlists (subdomains ~170,
   usernames ~90), GHDB dork starter set (~40), SecLists on-demand fetcher

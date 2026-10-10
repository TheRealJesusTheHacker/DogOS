# DogOS

**"All Dogs Go To Heaven."**

DogOS is a security and penetration-testing Linux distribution, built from
scratch on Debian testing with a Kali-style rolling toolset. MATE on X11 for
maximum tool compatibility. Two flavors: kitchen-sink `full` and live-USB
friendly `lite`.

## Highlights

- **Pentest toolkit** — Kali metapackages (top10 for lite, everything for full)
  plus DogOS layers: OSINT, anonymity, AI, dark-web
- **Anonymity** — Tor, I2P, `dogos-ghost` (transparent/per-app routing,
  killswitch, captive-portal hatch), `dogos-leaktest` verification
- **Amnesiac live mode** — Tails-style: RAM-only `toram` boot option, always-on
  MAC randomization, randomized hostname on live boot
- **Hardened defaults** — AppArmor, Bubblewrap, nftables default-deny incoming,
  no listening services, password-required sudo, LUKS via installer
- **Local AI** — Ollama/llama.cpp by default; cloud APIs strictly opt-in
- **OSINT toolkit** — installable tools, 30-service browser bookmark pack,
  wordlists, GHDB dork starters, SecLists fetcher
- **Installer** — graphical Calamares with DogOS branding

## Repo layout

- `design-spec.md` — living design document (decisions, architecture)
- `security-review-2026-10-10.md` — adversarial review, folded into the spec
- `osint-toolkit.md` — full OSINT resource inventory
- `dogos-livebuild/` — live-build config tree (package lists, hooks, includes,
  `build.sh` for the `full`/`lite` flavors)
- `dogos-extras/` — small signed APT repo scaffold for DogOS-native packages
  (`dogos-scripts`: engage/ghost/ai-setup/leaktest/hostname helpers)
- `assets/` — branding (wallpaper, logo references)

## Building

Needs a Debian host with `live-build` 3.x, ~20 GB free disk, root:

```sh
cd dogos-livebuild
./build.sh lite     # or ./build.sh full
cd /tmp/dogos-build-lite && sudo lb build
mv live-image-*.iso dogos-lite.iso
```

See `dogos-livebuild/README.md` for live-build 3.x notes (hook layout,
`noauto`, bootloader).

## Status

Design-complete and scaffold-validated (`lb config` passes against live-build
3.x). No release ISO yet — first build targets real hardware. Release
codenames: dog breeds, starting with **Doberman**.

Built by Sentinel Safeguard LLC.

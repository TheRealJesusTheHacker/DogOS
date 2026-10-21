# DogOS

**"All Dogs Go To Heaven."**

DogOS is a Debian-based security and penetration-testing Linux distribution:
a rolling, Kali-style attack distro with anonymity, an amnesiac live mode,
hardening by default, and local-AI tooling built in as first-class layers —
assembled from this source tree with Debian live-build.

[![CI](https://github.com/TheRealJesusTheHacker/DogOS/actions/workflows/ci.yml/badge.svg?style=flat-square)](https://github.com/TheRealJesusTheHacker/DogOS/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/TheRealJesusTheHacker/DogOS?include_prereleases&style=flat-square)](https://github.com/TheRealJesusTheHacker/DogOS/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
[![Base: Debian testing](https://img.shields.io/badge/base-Debian_testing_%28forky%29-red.svg?style=flat-square)](https://www.debian.org/releases/testing/)
[![Status: prerelease](https://img.shields.io/badge/status-prerelease-orange.svg?style=flat-square)](https://github.com/TheRealJesusTheHacker/DogOS/releases)

**Status: prerelease — complete source, no bootable ISO yet; the first ISO targets real hardware.**

## Contents

- [What DogOS is](#what-dogos-is)
- [Who it's for](#who-its-for)
- [Getting DogOS](#getting-dogos)
- [Flavors](#flavors)
- [Feature rundown](#feature-rundown)
- [How the pieces fit together](#how-the-pieces-fit-together)
- [Building from source](#building-from-source)
- [Configuration](#configuration)
- [Development and testing](#development-and-testing)
- [Status and roadmap](#status-and-roadmap)
- [Documentation](#documentation)
- [Security](#security)
- [Contributing](#contributing)
- [Contact](#contact)
- [Third-party software](#third-party-software)
- [License](#license)
- [Donations](#donations)

## What DogOS is

DogOS is a security and penetration-testing Linux distribution, built from
scratch on Debian and designed as a complete working environment for offensive
security. It is a rolling distribution in the Kali tradition: a Debian testing
base (codename `forky` at time of writing) with the Kali archive wired in
(kali-rolling, fingerprints verified against Kali's published key values), so
the toolset stays current instead of freezing on a point release.

The desktop is MATE on X11 with LightDM — chosen for maximum compatibility
with pentest tooling rather than visual novelty. DogOS ships two flavors from
one live-build tree: **full**, a kitchen-sink ~10–11 GB ISO with every Kali
metapackage for installed/VM use, and **lite**, a ~4–5 GB live-USB-friendly
ISO that still carries the complete DogOS recon layers (OSINT, anonymity,
AI). Both flavors are assembled by `dogos-livebuild/build.sh`, which
overlays `flavors/lite/` onto the base config tree.

What makes DogOS distinct from a stock Kali or Parrot is the layer around the
tools:

- **DogOS-native helper CLI** (`dogos-engage`, `dogos-ghost`, `dogos-ai-setup`,
  `dogos-leaktest`, `dogos-hostname`) — shipped as the `dogos-scripts` Debian
  package (0.2.0), making opsec workflows like Tor transparent-routing and
  firewall exceptions one command instead of a checklist.
- **Anonymity as a first-class feature** — Ghost mode (one-click transparent
  Tor routing with killswitch), a captive-portal escape hatch for hostile
  networks, and an honest leak-verification tool that reports what it finds
  rather than what you want to hear.
- **Amnesiac live mode, Tails-style** — a dedicated boot-menu entry runs the
  whole system from RAM (`toram`), MAC addresses randomize on every boot
  (live or installed), and live sessions get a fresh random hostname.
- **Hardened by default, firewall stays on** — nftables default-deny incoming,
  AppArmor, Bubblewrap, no listening services, Bluetooth off, LUKS offered in
  the installer. During engagements you open *explicit, visible* exceptions
  with `dogos-engage` instead of disabling the firewall.
- **Local-AI privacy default** — llama.cpp ships in the image; Ollama and a
  default model install on demand via `dogos-ai-setup`. Cloud APIs are
  strictly opt-in — engagement data never leaves the machine unless you say so.

The project is designed in the open: `design-spec.md` is the living design
document, `security-review-2026-10-10.md` records the adversarial review whose
findings were folded back into the build, and `osint-toolkit.md` is the full
OSINT resource inventory. Release codenames are dog breeds, starting with
**Doberman** (v0.1.0).

**Not the Cyra appliance.** DogOS is a clean-sheet pentest distro, separate
from the Cyra (formerly J.A.D.E.) project — that separation is a recorded
design decision (`design-spec.md` §2). The J.A.D.E. → Cyra rename did not
rename DogOS: the OS keeps its name, and Cyra is not DogOS's shell or
control point. DogOS's AI layer is the local-model tooling described under
[Local AI](#local-ai) — nothing more is claimed for it.

## Who it's for

- Penetration testers and red teams who want an attack distro with anonymity
  and opsec helpers baked in, not bolted on.
- Security researchers and OSINT investigators who need a stocked recon
  environment on a live USB.
- Students learning offensive security on a rolling, Debian-familiar base.
- The Cyberdogs — this is the pack's home distro.

**Legal note:** DogOS is an *attack* distro. Use its tooling only on systems
you own or are explicitly authorized to test — never without a signed
authorization in place. The maintainers are not responsible for misuse.

## Getting DogOS

There is **no ISO to download yet**. The GitHub Releases for this repo are
source prereleases (v0.1.0 and v0.1.1 "Doberman"); no bootable image is
attached to either. To run DogOS today you build the ISO yourself from this
source tree on a Debian host — see [Building from source](#building-from-source)
below for the honest requirements (real hardware, ~25 GB free disk for the
full flavor). The first GPG-signed ISO with published checksums is on the
roadmap under [Status and roadmap](#status-and-roadmap).

## Flavors

| | `dogos-full` | `dogos-lite` |
|---|---|---|
| Target | Installed systems, VMs | Live USB, quick recon |
| ISO size | ~10–11 GB | ~4–5 GB |
| Pentest set | All 15 Kali metapackages + verified additions | `kali-tools-top10` + verified additions |
| DogOS layers (OSINT / anonymity / AI) | Included | Included |
| Dev + applications layer | Included | — (intentionally empty override) |

Both flavors share the identity, hardening, amnesiac, and installer stack.
Flavors work by overlay: `build.sh` copies the tree to a fresh
`mktemp`'d `/tmp/dogos-build-XXXXXXXX/` dir (a unique path per run — never a
fixed dir, which would be a local symlink-plant/TOCTOU target) and overlays
`flavors/lite/` for lite — any file placed under `flavors/lite/config/`
replaces the same path under `config/`. The script prints the build dir
when it runs; remove it yourself after the ISO is built.

## Feature rundown

### Pentest toolkit

- **Full flavor:** all fifteen Kali metapackages (`kali-tools-top10`,
  `-information-gathering`, `-vulnerability`, `-web`, `-database`,
  `-passwords`, `-wireless`, `-reverse-engineering`, `-exploitation`,
  `-sniffing-spoofing`, `-post-exploitation`, `-forensics`, `-reporting`,
  `-crypto-stego`, `-hardware`) plus verified additions from the live
  Debian/Kali archives: `ffuf`, `gobuster`, `chisel`, `bloodhound`,
  `hcxtools`, `hcxdumptool`, `ghidra`, `valgrind`, `slowloris`, `beef-xss`
  (also pulled in by `kali-tools-exploitation`; listed explicitly so both
  flavors document it the same way).
- **Lite flavor:** `kali-tools-top10` plus the lean verified additions
  (`ffuf`, `gobuster`, `chisel`, `hcxtools`, `hcxdumptool`, `slowloris`,
  `beef-xss`). Bloodhound and Ghidra stay full-only deliberately — their
  ~1.3 GB would break lite's live-USB budget.

### OSINT mega-pack

Installable tools (`theharvester`, `recon-ng`, `spiderfoot`, `sublist3r`,
`amass`, `subfinder`, `dnsrecon`, `dnsenum`, `fierce`, `metagoofil`,
`whois`, `exiftool`, `torbrowser-launcher`, `dnstwist`, `instaloader`,
`sherlock`, `photon`, `finalrecon`) plus a resource directory at
`/usr/share/dogos/osint/`:

- `bookmarks.html` — 30-service Firefox bookmark pack (import via
  Bookmarks → Manage → Import)
- `wordlists/subdomains-starter.txt` (~190 entries),
  `wordlists/usernames-common.txt` (~95 entries)
- `dorks/ghdb-starter.txt` — ~30 classic Google Hacking Database dorks
- `keys.env.template` — 14 API-key fields covering 12 services (Shodan,
  Censys, BinaryEdge, GreyNoise, VirusTotal, AbuseIPDB, urlscan,
  SecurityTrails, Hunter, Dehashed, Intelligence X, Wigle); copy to
  `~/.config/dogos/osint/keys.env`
- `fetch-seclists.sh` — pulls the full SecLists corpus on demand so the
  ISO stays lean while starter lists ship regardless

A dedicated OSINT category ships in the MATE menu.

### Anonymity and Ghost mode

Packages: `tor`, `torsocks`, `proxychains4`, `nyx`, `onionshare`, `i2pd`,
`obfs4proxy`, `dnscrypt-proxy`, `privoxy`, `bind9-dnsutils` (the `dig` that
`dogos-leaktest` uses for its egress check).

`dogos-ghost` implements AnonSurf-style transparent Tor routing:

```
dogos-ghost on       # route all TCP/DNS through Tor (with killswitch)
dogos-ghost off      # back to direct traffic
dogos-ghost portal   # 5-minute captive-portal hatch for hotel/cafe logins
dogos-ghost status   # is Ghost mode on? is tor running?
dogos-ghost per-app  # per-app routing cheat sheet (torsocks, proxychains4)
```

**Portal-hatch detail:** `portal` arms the 5-minute auto re-enable with a
timestamped marker in `/run` — the timer only fires if the marker still
exists and the full 5 minutes have elapsed. Running `on` or `off` cancels
it, so an `off` after `portal` can never silently re-enable Tor, and a
second `portal` extends the hatch instead of stacking timers.

Mechanism: an nftables `nat` table redirects TCP → Tor's TransPort (9040)
and DNS → Tor's DNSPort (5353), with Tor's own traffic excluded by UID so it
can't loop back into itself. The script refuses to enable if the TransPort
isn't listening after 30 seconds — your network is left untouched rather
than half-configured.

**Honest limits, stated up front:** Ghost mode is scoped to the
recon/anonymity phase. Non-DNS UDP and ICMP bypass Tor entirely; many targets
block Tor exits; latency kills interactive shells. Run `dogos-leaktest`
after enabling:

```
dogos-leaktest   # Tor check via check.torproject.org + DNS egress check
```

It reports `IsTor` and which resolver IP outsiders see, and tells you what
the results mean with Ghost on vs. off — no theater.

### Amnesiac live mode

- **Boot-menu entry "DogOS amnesiac (RAM only)"** — a binary-stage build
  hook clones the default syslinux/GRUB live entries and adds `toram`, so the
  whole system runs from RAM and nothing is written to host disks. The hook
  is defensive: it probes each bootloader layout and skips with a warning
  when a path is unrecognized.
- **MAC randomization, always on** — NetworkManager config randomizes Wi-Fi
  scan MACs and both Ethernet/Wi-Fi connection MACs on *every* boot, live or
  installed.
- **Random hostname on live boot** — the `dogos-hostname` systemd service
  sets a fresh identity (`dogos-hound-4821`, `dogos-shadow-7390`, …) only
  when booted from live media; installed systems keep their configured name.

### Hardening defaults

- nftables default-deny incoming (base ruleset ships in the image; the
  service is enabled at build time)
- AppArmor with profiles and utils; Bubblewrap installed
- Bluetooth disabled by default (one click to re-enable); `avahi-daemon`,
  `cups`, `rpcbind`, and `nfs-client.target` masked — no listening services
  out of the box
- Sudo requires the user password (no NOPASSWD) on installed systems; LUKS
  full-disk encryption offered in the installer. Live sessions use the
  standard Debian live user (`user`) with passwordless sudo — expected on
  live media, stripped from installed systems by `dogos-install-cleanup`.
  The live user's password is randomized on every live boot by
  `dogos-live-password` and shown on the login screen (D-13, decided
  2026-10-21): live media carries no known credential, and if
  randomization fails the live account is locked rather than falling
  back to a known password.
- Hardening sysctls (`config/includes.chroot/etc/sysctl.d/99-dogos.conf`):
  IP forwarding off; ICMP redirects and source routing refused (send and
  accept, all and default); broadcast echo ignored; SYN cookies on;
  `kernel.dmesg_restrict = 1`; `kernel.kptr_restrict = 2`; unprivileged BPF
  disabled (`kernel.unprivileged_bpf_disabled = 2`,
  `net.core.bpf_jit_harden = 2`); and `kernel.yama.ptrace_scope = 1` — set
  to 1 rather than 2 deliberately: the distro ships its own debuggers (gdb
  and friends), and 2 would block unprivileged ptrace of even the user's
  own processes (the rationale is recorded in the file itself). Tools that
  need relaxed settings get them explicitly via `dogos-engage`, never by
  weakening these defaults.

### Local AI

- `llama.cpp` ships in the image
- `dogos-ai-setup` installs Ollama (official install script, SHA256-verified
  against a pinned hash before it runs as root — fail-closed if Ollama
  rotates the script) if missing and
  pulls the default local model (`qwen2.5-coder:7b`, override with
  `DOGOS_AI_MODEL=…`). Model weights are **never** baked into the ISO.
- **Privacy default: local models only.** Cloud-backed assistants
  (Shell-GPT, aichat) are queued in `dogos-extras` as hash-pinned vendored
  wheels and require explicit opt-in — engagement data never leaves the
  machine unless you say so.
- A pentest-copilot system-prompt pack (prebuilt personas for recon,
  exploitation, reporting) is on the roadmap.

### Dev + applications layer (full flavor only)

Neovim, Go/Rust toolchains, CLI power tools, and applications (KeePassXC,
OBS, GIMP, …), plus containers: `docker.io`, `podman`, `docker-compose`.

**Docker caveat:** membership in the `docker` group is effectively root —
the daemon runs as root, and `docker run -v /:/host …` owns the box.
Treat `docker` group membership like sudo: grant it only to the admin
user, never to shared or low-privilege accounts. Docker stays in the full
flavor for pentest workflows; this is a configuration note, not a removal.

### DogOS helper scripts (`dogos-scripts` 0.2.0)

The first native DogOS package, shipped in `dogos-extras/staging/` and
installable with `sudo dpkg -i dogos-scripts_0.2.0_all.deb`:

| Script | What it does |
|---|---|
| `dogos-engage` | Explicit firewall exceptions for engagements: `open <ports…>` / `close` / `status` operate on an idempotent `engage_ports` nftables set (close never disturbs Ghost mode); `route on|off` toggles IP forwarding for MITM/pivot work |
| `dogos-ghost` | One-click transparent Tor routing (see above) |
| `dogos-ai-setup` | Install Ollama + pull the default local model |
| `dogos-leaktest` | Verify Ghost mode isn't leaking |
| `dogos-hostname` | Randomize hostname on live boot |

All five are syntax-checked and shellcheck-clean in CI. (`dogos-install-cleanup`
ships separately in the ISO via `includes.chroot` — it runs on installed
systems, not live media, so it isn't part of the `dogos-scripts` .deb.)
The staged `.deb` was rebuilt on 2026-10-13 from the current in-tree
scripts, so it matches the hardened `includes.chroot` versions rather than
the original pre-hardening build (see `dogos-extras/README.md`).

### Installer and branding

- Graphical Calamares installer with DogOS branding
- First-boot cleanup on installed systems: `dogos-install-cleanup` runs once
  (before the login screen) to remove the live-session user, its
  passwordless-sudo grant, and the live autologin config — installed systems
  boot to a real login for the user created in the installer
- Animated Plymouth boot splash (8-frame pulsing Doberman theme)
- Dark hacker wallpaper set as the MATE default via dconf
- ISO publisher: Sentinel Safeguard LLC

### `dogos-extras` — the signed APT repo

`dogos-extras/` is a small signed APT repository scaffold (reprepro-based)
for everything Debian doesn't ship:

- **Packaged:** `dogos-scripts` 0.2.0 (engage/ghost/ai-setup/leaktest/hostname)
- **Queued (pip → vendored, hash-pinned):** holehe, maigret, snscrape,
  shodan, social-analyzer, toutatis, whisper
- **Queued (manual builds):** phoneinfoga, onionsearch, blackbird, ghunt,
  ligolo, cutter
- **Queued (upstream debs, mirrored + verified):** feather-wallet,
  yggdrasil, retroshare, gh (GitHub CLI), android-tools-adb/fastboot, bless
- **Rejected after audit (2026-10-10):** LOIC — no maintained port exists;
  modern stress tools (slowloris, hping3) cover the capability

`scripts/import-deb.sh` imports packages, `scripts/export-key.sh` publishes
the repo key. The signing-key ID and repo URL are intentionally left as TODO:
Skyler generates the offline master key on an air-gapped machine first, and
no placeholder source is added to the image before then — a dead `URIs:`
entry would break `apt update` on every boot.

## How the pieces fit together

```
design-spec.md            living design document — decisions, architecture
security-review-*.md      adversarial review (findings folded into the spec)
osint-toolkit.md          full OSINT resource inventory
dogos-livebuild/          the live-build config tree
  auto/config             live-build entrypoint (lb config, 3.x CLI)
  config/package-lists/   APT layers: desktop, pentest, osint, anonymity,
                          ai, hardening, firmware, dev (full-only)
  config/archives/        Kali archive source + verified keyring
  config/hooks/           build hooks: branding, hardening, scripts,
                          amnesiac toram boot entry
  config/includes.chroot/ files overlaid into the live system
                          (dogos-* helpers, nftables rules, sysctls,
                          wallpaper, Plymouth theme, Calamares branding,
                          OSINT resource dir)
  flavors/lite/           overlay that trims the tree for the lite ISO
  build.sh                assembles a flavor, runs auto/config
dogos-extras/             signed APT repo scaffold + first native package
assets/                   branding (wallpaper, logo references)
```

A build flows: `build.sh [full|lite]` → assemble tree → `./auto/config` →
`sudo lb build` → rename `live-image-*.iso`. Build hooks fire inside the
chroot (branding, hardening) and at the binary stage (amnesiac boot entry);
everything under `includes.chroot/` lands in the live filesystem verbatim.

At runtime the image is held together by a small set of systemd units and
shipped defaults rather than daemons of its own: the hardening hook enables
the `nftables` base ruleset and AppArmor, `dogos-hostname` (live-boot
identity), and `dogos-install-cleanup` (first boot on installed systems) —
and warns loudly in the build log if any of those enables silently failed
to land. Everything else — Ghost mode, engagement exceptions, AI setup —
is an explicit operator command, run when the operator asks for it.

## Building from source

**Honest requirements:** a full `lb build` is heavy — use real hardware (a
Debian host with live-build 3.x — the tree was validated against 3.0~a57 —
~25 GB free disk for `full`, root access).
CI only syntax-checks and lints the scripts; nobody's building a 10 GB ISO
in a free CI runner.

```sh
# Debian build host
sudo apt install live-build

git clone https://github.com/TheRealJesusTheHacker/DogOS.git
cd DogOS/dogos-livebuild

./build.sh lite     # or ./build.sh full (default)
# cd into the build dir build.sh just printed (unique mktemp'd /tmp/dogos-build-XXXXXXXX/)
cd /tmp/dogos-build-XXXXXXXX   # ← replace with the printed path
sudo lb build

# live-build 3.x dropped --image-name; rename the output
mv live-image-*.iso dogos-lite.iso
```

Before building, verify the Debian testing codename in `auto/config`
(`forky` at time of writing) and every package name with
`apt-cache policy` — the lists were verified against the live Debian/Kali
archives on 2026-10-10, but a rolling base moves.

See `dogos-livebuild/README.md` for live-build 3.x notes (flat hook layout,
`noauto` first, singular `--bootloader`).

## Configuration

DogOS is configured in the open — every default below is a file in this
repo, not a hidden setting:

- **Build** — `dogos-livebuild/auto/config` holds the live-build settings:
  distribution (`forky`), archive areas (`main contrib non-free
  non-free-firmware`), `--debian-installer live`, singular `--bootloader
  grub`, `iso-hybrid` binary image, and the ISO application / publisher /
  volume strings. `build.sh` takes one argument, `full` (default) or
  `lite`.
- **Packages** — one list per layer in
  `dogos-livebuild/config/package-lists/` (`dogos-*.list.chroot`); the lite
  overrides live under `dogos-livebuild/flavors/lite/config/package-lists/`.
- **Firewall** — the base ruleset is
  `config/includes.chroot/etc/nftables.conf` (default-deny incoming).
  Engagement exceptions belong in its `engage_ports` set, managed by
  `dogos-engage` — not in edits to the base rules mid-engagement.
- **Kernel hardening** — `config/includes.chroot/etc/sysctl.d/99-dogos.conf`
  (itemized under [Hardening defaults](#hardening-defaults)).
- **MAC randomization** —
  `config/includes.chroot/etc/NetworkManager/conf.d/30-dogos-mac.conf`.
- **Local AI model** — the `DOGOS_AI_MODEL` environment variable overrides
  the default model `dogos-ai-setup` pulls (`qwen2.5-coder:7b`).
- **OSINT API keys** — copy
  `config/includes.chroot/usr/share/dogos/osint/keys.env.template` to
  `~/.config/dogos/osint/keys.env` and fill in the services you use. No key
  values are baked into the image.
- **Kali archive** — `config/archives/kali.list.chroot` plus the bundled
  keyring. Read `config/archives/README.md` before touching either: it
  records which keyring fingerprints are verified against Kali's published
  values and which are not.

## Development and testing

There is deliberately **no ISO build in CI** — a full `lb build` is a
multi-hour, ~25 GB job on rolling Debian testing and belongs on real
hardware. The pre-merge gate (`.github/workflows/ci.yml`, on push and pull
request to `main`, actions pinned by SHA) is:

- every shell script in the repo must parse (`bash -n`), and
- every shell script must pass `shellcheck` at severity `warning` and
  above.

Run the same checks locally before pushing (mirrors the workflow):

```sh
# from the repo root
grep -rlE --exclude-dir=.git \
  '^#!(/(usr/)?bin/(ba|da)?sh|/usr/bin/env (ba)?sh)' . \
  > /tmp/shell-files.txt
while IFS= read -r f; do bash -n "$f"; done < /tmp/shell-files.txt
xargs -a /tmp/shell-files.txt shellcheck -S warning --
```

Beyond the gate: `lb config` passes against live-build 3.x (validated
2026-10-10 against 3.0~a57; see `dogos-livebuild/README.md`), and the
package lists were verified against the live Debian forky / Kali rolling
archive indices on 2026-10-10 — re-verify with `apt-cache policy` before a
build, because a rolling base moves. Nothing has been boot-tested yet: no
ISO has been built, so no hardware validation is claimed anywhere in this
project.

## Status and roadmap

- **v0.1.0 "Doberman" (2026-10-11)** — first public prerelease: complete
  project source, live-build tree (full + lite), `dogos-extras` scaffold,
  design spec, security review, OSINT inventory. No ISO attached yet.
- **v0.1.1 "Doberman" (2026-10-11)** — hardening and premium repo polish:
  MIT license, expanded README, CI gate (`bash -n` + shellcheck,
  SHA-pinned actions), SECURITY.md, issue/PR templates. No ISO attached
  yet.
- **Design-complete, scaffold-validated** — `lb config` passes against
  live-build 3.x; package lists verified against Debian forky/Kali rolling.
- **No bootable ISO yet** — the first ISO build targets real hardware.

Planned (roadmap, not yet implemented):

- First bootable ISO (full + lite), GPG-signed with checksums and a
  fingerprint published out-of-band
- Weekly automated build + boot smoke test (bit-rot defense for a rolling
  base) — ADOPTED (D-7, decided 2026-10-21): takes effect once the
  first ISO exists (the first build is owner-hands, D-3)
- `dogos-extras` going live: offline master signing key, repo URL, client
  apt config in the image, queued packages vendored in
- Firefox Bubblewrap sandbox wrapper — SHIPPED in the live-build tree
  (D-8, 2026-10-21): wrapper + desktop override in `includes.chroot`;
  sandbox validation rides the first ISO build (D-3)
- Pentest-copilot system-prompt pack — KEPT (D-12, decided 2026-10-21):
  authored once the ISO line is live
- Live-boot credentials: randomized per boot and shown on the login
  screen (D-13, decided 2026-10-21; implemented in the live-build
  tree, validation rides the first ISO build); installer forces a
  real password
- Periodic snapshot ISOs; rolling updates via APT `dist-upgrade`

## Documentation

- `design-spec.md` — the living design document: decisions and architecture.
- `security-review-2026-10-10.md` — the adversarial review of the design,
  with findings folded back into the build.
- `osint-toolkit.md` — the full OSINT resource inventory.
- `dogos-livebuild/README.md` — live-build 3.x notes for the build tree.
- `dogos-extras/README.md` — the signed APT repo scaffold and its package queue.
- [CHANGELOG.md](CHANGELOG.md) — release history.
- [SECURITY.md](SECURITY.md) — how to report a vulnerability, and the
  project's threat model.

## Security

DogOS is an *attack* distro — it assumes the operator is the trusted party
working from potentially hostile networks. It protects operator anonymity
(Ghost mode, amnesiac live boot) and data at rest (LUKS). Toolkit integrity
via signed repos and checksummed ISOs is **roadmap, not yet implemented**
(see SECURITY.md) — no ISO or signed repo exists yet. It does **not** claim to defend against
physical seizure of an unlocked machine, operator OPSEC failures, or targeted
endpoint compromise by a well-resourced adversary. It is not Qubes — its job
is keeping the operator safe while they work.

To report a security issue, see [SECURITY.md](SECURITY.md) — reports go to
Sentinelsafeguard@outlook.com. Please do not open public issues for
vulnerabilities.

## Contributing

Pull requests are welcome. Two house rules:

1. **Intended functionality comes first.** Fix issues around the features
   described here — never strip or neuter a feature to satisfy a linter or
   scanner. If a finding can't be fixed without breaking intended behavior,
   document why and leave it.
2. **Don't change script interfaces** — the `dogos-*` CLI contracts are
   stable. CI runs `bash -n` and shellcheck over every shell script; keep
   them clean.

See the [pull request template](.github/PULL_REQUEST_TEMPLATE.md) for the
checklist.

## Contact

Business inquiries: **Sentinelsafeguard@outlook.com**

## Third-party software

DogOS is built from and with open-source projects — their own licenses
apply to their work; DogOS's own code is MIT (see below). Highlights:

- **Kali Linux** — the Kali archive (`kali-rolling`) supplies the pentest
  toolset; keyring fingerprints verified against Kali's published values
  (see `dogos-livebuild/config/archives/README.md`). https://www.kali.org
- **Debian live-build** — assembles the ISO from this config tree (GPL-3.0).
  https://salsa.debian.org/live-team/live-build
- **Calamares** — graphical system installer (GPL-3.0).
  https://calamares.io
- **SecLists** — on-demand wordlist corpus, fetched at a pinned commit
  (MIT); the starter lists in-tree are DogOS-curated.
  https://github.com/danielmiessler/SecLists
- **Exploit-DB GHDB** — the dork patterns in the in-tree starter set are
  modeled on this corpus. https://www.exploit-db.com/google-hacking-database
- **Tor, nftables, MATE, Plymouth** — ship as distro packages, used
  unmodified from the Debian/Kali archives. https://www.torproject.org ·
  https://netfilter.org · https://mate-desktop.org ·
  https://www.freedesktop.org/wiki/Software/Plymouth/

## License

MIT — see [LICENSE](LICENSE).

---
*Built by Cyberdogs — the unofficial side of Sentinel Safeguard LLC.*

## Donations

If this tool earned its keep, BTC is welcome:

```
bc1qvydns2fmyjzj55wzxq7ta28nxdhcmu9l9m6yg0
```

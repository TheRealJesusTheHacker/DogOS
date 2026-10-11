# DogOS Design Spec — release "Doberman"

_Living design document. Updated as decisions get made. Started 2026-10-10._

## 1. Identity
- **Name:** DogOS (decided 2026-10-10)
- **Logo:** the Cyberdogs geometric black-and-tan Doberman head (`~/workspace/your_files/brand/cyberdogs-logo.jpg`)
- **Boot splash:** animated splash screen featuring the logo (Plymouth theme — build task)
- **Wallpaper:** dark hacker theme built around the logo (decided 2026-10-10) — v1 draft: `~/workspace/os-design/assets/media-generation-dogos-wallpaper-v1-0-e33e9431-bfb2-41ba-b1f2-083ecaa9bf9a.webp`
- **Codename:** dog breeds; first release "Doberman" (decided 2026-10-10)
- **Tagline:** "All Dogs Go To Heaven" (decided 2026-10-10)

## 2. Mission
_What is this OS for? Who is it for? What does it do better than anything else?_
- **Security and penetration testing distribution** — offensive-security focus (decided 2026-10-10). A clean-sheet pentest distro, separate from J.A.D.E. OS.
- **Differentiator (v1, per Skyler):** distinct visual identity — custom wallpaper, logo, animated boot splash screen. Ships the Parrot + Kali toolsets plus additional curated tools (list TBD).

## 3. Base & lineage
- **Upstream base:** Debian (decided 2026-10-10)
- **Why this base:** stable foundation, massive package/tooling ecosystem, Kali/Parrot precedent, prior live-build experience

## 4. Architecture
- **Target arches:** x86_64 only (decided 2026-10-10) — single build/test matrix
- **Kernel:** stock Debian kernel, max compatibility (decided 2026-10-10)
- **Init system:** systemd (Debian default)

## 5. Package management
- **Package format/manager:** APT/dpkg (inherited from Debian)
- **Release model:** Rolling on Debian testing, Kali-style (decided 2026-10-10) — fresh pentest tooling over stability
- **Repos:** inherit Debian + Kali repos; small signed `dogos-extras` APT repo carrying only what Debian lacks (LOIC fork, repackaged OSINT/AI pip tools, dogos-ai-setup, Ghost mode scripts) — added 2026-10-10 per security review
- **Supply chain:** Debian packages preferred always; pip installs hash-pinned (`--require-hashes`) with wheels vendored into dogos-extras — added 2026-10-10 per security review

## 6. Shell & desktop
- **Default interface:** MATE, Parrot-style (decided 2026-10-10)
- **Display server:** X11, max tool compatibility (decided 2026-10-10)

## 7. Security model
- **Threat model (draft 2026-10-10):** DogOS is an *attack* distro — it assumes the operator is the trusted party working from potentially hostile networks. It protects: operator anonymity (Ghost mode, amnesiac live-boot), data at rest (LUKS), toolkit integrity (signed repos, checksummed ISOs). It does NOT claim to defend against: physical seizure of an unlocked machine, operator OPSEC failures, or targeted endpoint compromise by a well-resourced adversary. It is not Qubes — its job is keeping the operator safe while they work, not being an impregnable fortress.
- **Default privilege model:** non-root user + sudo, modern standard (decided 2026-10-10); sudo requires the user password (no NOPASSWD) — set 2026-10-10 per security review
- **Hardening defaults:** nftables, default-deny incoming (decided 2026-10-10); no listening network services by default; Bluetooth disabled by default (one-click enable); `dogos-engage` helper opens explicit listener ports (idempotent set-based rules; `close` never disturbs ghost mode) and toggles IP forwarding for MITM/pivot work (`route on|off`) so the firewall stays on during engagements — set 2026-10-10 per security review, hardened 2026-10-11
- **MAC framework:** AppArmor, Debian default (decided 2026-10-10)
- **Sandboxing:** Bubblewrap profiles for high-risk apps — browser first, then untrusted-input parsers — set 2026-10-10 per security review (X11 keylogging mitigation). (Firejail originally specified; verified 2026-10-10 absent from both Debian forky and Kali rolling archives — Bubblewrap is the available path.)
- **Encryption:** LUKS full-disk encryption offered in installer (opt-in)
- **Live-boot credentials:** documented loudly or randomized per boot; installer forces a real password — set 2026-10-10 per security review

## 8. Networking
- **Defaults:** NetworkManager; no listening services by default; Ghost mode (transparent Tor) available one-click

## 9. Default tooling & applications
- **Tooling philosophy:** Kitchen sink, Kali-style — hundreds of tools preinstalled (decided 2026-10-10). Two flavors from 2026-10-10: `dogos-full` (everything) + `dogos-lite` (top10 + DogOS layers).
- **Additional curated tools beyond Kali/Parrot:**
  - LOIC: **REJECTED after audit (2026-10-10)** — no maintained Java port exists (the premise was wrong); the C# original is dormant since ~2014 and needs Mono on Linux; all forks are dead (2012–2020) or obscure single-maintainer projects. Capability already covered by hping3; modern candidates for the dogos-extras queue: T50, slowloris, Anevicon.
  - **OSINT mega-pack** (added 2026-10-10, per Skyler: "as many OSINT resources as we can") — full candidate inventory: `osint-toolkit.md`. Three layers: installable tools, curated bookmark pack for web-only services, API-key template dir. Dedicated "OSINT" MATE menu category.
- **AI tools** (added 2026-10-10):
  - Ollama — local LLM server (manual install; not in Debian repos)
  - llama.cpp — inference engine (packagable)
  - GPT4All / Jan — desktop LLM apps (manual install)
  - Shell-GPT (`sgpt`, pip) — terminal AI assistant
  - `aichat` — CLI front-end for multiple LLM APIs
  - **AI privacy default: local models only** (Ollama/llama.cpp) — cloud APIs require explicit opt-in behind a warning banner; engagement data never leaves the machine by default — set 2026-10-10 per security review
  - `dogos-ai-setup` script — pulls a recommended model on first run (keeps the ISO lean; model weights are GBs, never baked into the image)
  - DogOS pentest-copilot system prompt pack — prebuilt assistant personas for recon, exploitation, reporting
- **Dark web / anonymity** (added 2026-10-10):
  - Tor Browser + tor daemon, obfs4 bridges, Snowflake pluggable transports
  - AnonSurf-style **"Ghost mode"** — one-click transparent Tor routing for all traffic, with killswitch. Scoped to the recon/anonymity phase: per-app routing (torsocks/proxychains profiles) offered alongside full-tunnel; docs state when to turn it OFF (exits get blocked, UDP/ICMP can leak around transparent proxying, latency kills shells); captive-portal escape hatch included — refined 2026-10-10 per security review
  - Nyx — Tor relay/monitor; proxychains, torsocks
  - OnionShare — anonymous file sharing over Tor
  - Onion service hosting wizard — easily host .onion sites/services
  - I2P (i2pd), I2P-Bote (anonymous email)
  - Yggdrasil — encrypted IPv6 meshnet
  - RetroShare — friend-to-friend encrypted comms; Briar — P2P messaging over Tor
  - Feather Wallet — privacy-preserving (Monero) payments
  - Ahmia [service] — onion search (in bookmark pack)
  - `dogos-leaktest` — Ghost mode leak verification (Tor check + DNS egress check), built 2026-10-10
  - **Amnesiac live-boot mode: YES** (decided 2026-10-10) — Tails-style: RAM-only session, no host traces, persistence strictly opt-in. Implemented 2026-10-10: MAC randomization always-on (NetworkManager conf), hostname randomized on live boot only (dogos-hostname systemd service), `toram` boot-menu entry via binary hook (clones the default syslinux/GRUB entries; defensive, validates at build).

## 10. Update & release engineering
- **Build system:** live-build 3.x (prior experience from J.A.D.E. OS v0.13.0) — auto/config validated 2026-10-10 against 3.0~a57 (flat config/hooks layout, `noauto` first, singular --bootloader grub)
- **Installer:** Calamares, graphical, DogOS-branded (decided 2026-10-10)
- **Build scaffold:** `~/workspace/os-design/dogos-livebuild/` — created 2026-10-10. Package lists (desktop/pentest/OSINT/anonymity/AI/hardening/firmware), 3 chroot hooks, `dogos-engage` / `dogos-ghost` / `dogos-ai-setup` helpers (syntax-checked), nftables base rules, hardening sysctls, wallpaper, OSINT resource stubs. DONE since: Plymouth animated splash (8 pulsing frames + script theme), Ghost mode nftables rules + captive-portal hatch, `dogos-extras` repo scaffold. DONE 2026-10-10: Kali archive wired — kali-rolling source + official 2025.3 keyring, fingerprints verified against Kali's published values (2025 key 827C8569F2518CC677FECA1AED65462EC8D5E4C5 ✓, pre-2025 key 44C6513A8E4FB3D30875F758ED444FF07D8D0BF6 ✓; third contained key present but unverified).
- **Update mechanism:** rolling via APT (`dist-upgrade`); periodic snapshot ISOs
- **Release integrity:** GPG-signed ISOs + checksums, fingerprint published out-of-band; offline master signing key — set 2026-10-10 per security review
- **Flavors (decided 2026-10-10):** `dogos-full` — kitchen sink, ~14.9 GB installed package set (2,625 packages, recursive Depends) → roughly a **10–11 GB ISO**; for installed/VM use. `dogos-lite` — kali-tools-top10 + the DogOS OSINT/anonymity/AI layers (which ship in both), ~5.3 GB → roughly a **4–5 GB ISO**; live-USB friendly. Built via `build.sh [full|lite]`, which overlays `flavors/lite/` onto the tree (measured 2026-10-10 against live archive indices).
- **First native package:** dogos-scripts 0.2.0 `.deb` built 2026-10-10 (engage/ghost/ai-setup/leaktest/hostname) — in `dogos-extras/staging/`.
- **CI:** weekly automated build + boot smoke test (bit-rot defense for rolling + kitchen sink) — set 2026-10-10 per security review

## Open questions
- (none yet)

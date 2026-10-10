# DogOS Security Review — 2026-10-10

_Status: all proposed fixes folded into `design-spec.md` on 2026-10-10 per Skyler's approval._

_Adversarial pass over `design-spec.md` v1. Findings ranked by severity._

## What's already solid
- Non-root + sudo, AppArmor on, nftables default-deny, no listening services, LUKS opt-in,
  amnesiac live-boot, signed-toolkit-integrity goal. The fundamentals are right.

## HIGH

### H1. Rolling + kitchen sink + one maintainer = bit-rot (project survival risk)
600+ tools on Debian testing breaks regularly. Kali survives this with a team, their own
repos, and CI. A one-person distro without a repo/CI strategy rots within months.
- **Proposed fix:** start with a small `dogos-extras` APT repo (signed) carrying only what
  Debian lacks (LOIC fork, OSINT pip tools repackaged, dogos-ai-setup, Ghost mode scripts);
  inherit everything else from Debian/Kali repos. Add a weekly automated build+boot smoke test.

### H2. pip / manual installs are an unsigned supply chain
Several chosen tools only exist via pip (Holehe, Maigret, sgpt) or git clones. pip has no
signatures — one compromised package poisons the ISO.
- **Proposed fix:** prefer Debian packages always; where pip is unavoidable, pin to hashes
  (`pip install --require-hashes`) and vendor the wheels into the dogos-extras repo.

### H3. AI cloud tools will exfiltrate engagement data by default
Shell-GPT and aichat default to cloud APIs (OpenAI etc.). Pasting target IPs, vulns, and
creds into a third-party API during an engagement is an OPSEC disaster.
- **Proposed fix:** DogOS AI layer defaults to **local models only** (Ollama/llama.cpp);
  cloud APIs require explicit opt-in behind a warning banner.

### H4. "Ghost mode routes everything through Tor" breaks pentesting (and leaks)
- Tor exit nodes are blocked by many targets; latency kills interactive shells.
- Transparent proxying cannot capture all UDP/ICMP — nmap UDP scans, ping, and sloppy DNS
  leak around Tor. This is the classic transparent-proxy pitfall.
- Running attacks through volunteer exit nodes burns goodwill and invites abuse complaints.
- **Proposed fix:** scope Ghost mode to the **recon/anonymity phase**, offer per-app routing
  (torsocks/proxychains profiles) alongside full-tunnel, document when to turn it OFF, and
  add a captive-portal escape hatch (a hard killswitch bricks coffee-shop Wi-Fi login).

## MEDIUM

### M1. LOIC's Java port is dead code
The cross-platform LOIC (Java) hasn't been meaningfully maintained in years. Shipping dead
code ships its vulnerabilities.
- **Proposed fix:** audit before packaging; if it's rotten, replace with maintained modern
  stress tools (hping3 is already in the Kali set) and keep the LOIC name out.

### M2. nftables default-deny fights pentest listeners
Reverse shells, Metasploit handlers, `python3 -m http.server` — engagements need inbound
listeners. Users will just disable the firewall (worse).
- **Proposed fix:** a `dogos-engage` helper that opens a defined listener port range / per-tool
  profiles, so the firewall stays on with explicit, visible exceptions.

### M3. X11 lets any app keylog — ironic for a security distro
The X11-for-compatibility call was explicit and reasonable, but name the cost: under X11,
any application can scrape keystrokes and screens.
- **Proposed fix:** fill the spec's empty "Sandboxing" line with **Firejail** (or Bubblewrap)
  profiles for high-risk apps — browser first, then anything parsing untrusted input.

### M4. Decide sudo posture now
Kali-style passwordless sudo would quietly undo the non-root model.
- **Proposed fix:** sudo requires the user password by default. (Recommend: yes.)

### M5. Amnesiac mode needs anti-fingerprinting details
Tails does more than RAM-only: MAC address randomization and hostname randomization on
every boot. A DogOS live-boot with a static MAC and hostname `dogos` is fingerprintable
on the local network.
- **Proposed fix:** add MAC + hostname randomization to the amnesiac-mode spec.

## LOW

### L1. ISO size vs. live-boot practicality
Kitchen sink + AI runtimes could push the ISO past 6 GB. That's a slow USB boot and heavy
RAM use in live mode.
- **Proposed fix:** measure early; if it hurts, split a `dogos-lite` netinstall ISO later.
  Don't pre-split — measure first.

### L2. "Signed ISOs" needs an implementation, not a sentence
Checksums + GPG signatures with a published, out-of-band fingerprint. Decide the signing
key story (offline master key) before the first public ISO.

### L3. Bluetooth on by default is attack surface
- **Proposed fix:** disabled by default, one click to enable (it's also a legit BLE-recon tool).

### L4. Live-boot default credentials
Document them loudly or randomize per boot; installer must force a real password.

## Deliberately NOT flagged
- Stock kernel / X11 / x86_64-only: explicit compatibility tradeoffs, coherent with the
  mission. Noted, not fought.
- Feather Wallet (Monero): legal privacy tooling, consistent with the anonymity story.
- I2P/Yggdrasil/Briar/RetroShare: unusual for a pentest distro, but that's differentiation,
  not a bug.

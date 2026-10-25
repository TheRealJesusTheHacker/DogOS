# DogOS supply chain — hash / signature verification

Fleet `--require-hashes` rollout, 2026-10-25. This file records, per install
path in this repo, which verification mechanism actually applies. Verdict up
front: **DogOS has no pip install surface in code today.** Every dependency
install that exists runs through Debian/Kali APT archives, whose signature
verification is this ecosystem's native equivalent of a hash lock. The two
runtime download scripts in the tree already pin sha256 hashes and fail
closed. Nothing in this document is a runtime or build claim — it is a
static audit of the tree at the commit this file landed in.

## 1. Live-build package lists (the OS payload)

- Paths: `dogos-livebuild/config/package-lists/*.list.chroot` (ai,
  anonymity, desktop, dev, firmware, hardening, osint, pentest) plus the
  lite-flavor overrides under `dogos-livebuild/flavors/lite/`.
- Mechanism: packages are fetched by live-build/debootstrap through APT
  from the Debian archive (`--distribution forky`, i.e. Debian testing) and
  the Kali archive (`dogos-livebuild/config/archives/kali.list.chroot` →
  `https://http.kali.org/kali kali-rolling`). APT verifies the archive's
  signed `Release`/`InRelease` metadata (against the Debian archive keyring
  and the Kali keyring shipped at
  `config/archives/kali-archive-keyring.key.chroot` — fingerprints and
  provenance are documented in `config/archives/README.md`) and then
  verifies every `.deb` against the sha256 in that signed metadata. A hash
  mismatch aborts the install. That chain — signed index + per-package
  sha256 — is the Debian ecosystem's hash-equivalent of
  `pip install --require-hashes`; there is no unsigned path to pin further.
- **Version pinning: none, deliberately.** The package lists name packages
  only, no versions. Both archives are rolling (Debian *testing*, Kali
  *rolling*): the archive contents move, and a version-pinned list would
  stop resolving as soon as the archive superseded those versions. What a
  build gets is therefore "the versions the signed archives serve on build
  day, signature- and hash-verified" — integrity is pinned, versions float
  by design of the distribution model. Reproducibility, if ever wanted, is
  a snapshot-archive question (e.g. snapshot.debian.org), not a lockfile
  question, and is out of scope here.
- `dogos-livebuild/auto/config` and `build.sh` add no other package
  sources: no pip, no npm, no `curl | sh`, no vendored tarballs. The chroot
  and binary hooks (`config/hooks/`) install nothing — they configure,
  enable/disable services, and set permissions only.

## 2. CI (`.github/workflows/ci.yml`)

- The gate is static: `bash -n` + shellcheck over the tree's shell scripts;
  it deliberately never runs `lb build`.
- Its only install is a fallback `sudo apt-get install -y shellcheck` when
  the runner image lacks shellcheck — again APT against the Ubuntu archive,
  signature-verified the same way as §1. No pip/npm installs exist in CI.

## 3. dogos-extras (the local APT repo)

- `dogos-extras/` is a reprepro repository skeleton for tools Debian does
  not ship, signed with a dedicated key (`conf/distributions` → `SignWith:`,
  still a placeholder `FILL-IN-SIGNING-KEY-ID`; `scripts/export-key.sh`
  refuses to run until a real key id is set). Packages enter only as `.deb`
  files via `scripts/import-deb.sh` and are served under that signature —
  clients verify them through APT exactly as in §1.
- The pip-origin tools named in comments/docs as future dogos-extras
  candidates (sgpt, aichat, holehe, maigret, snscrape, shodan, …) are
  **plans, not installs**: no wheels, no requirements files, and no pip
  commands exist in the tree today. When any of them is actually packaged,
  the standing rule from `security-review-2026-10-10.md` (H2) applies:
  build it from a `pip install --require-hashes` lock generated from a
  known-good resolution, vendor the wheel, and record the lock in this
  file's terms before the `.deb` is imported.

## 4. Runtime download scripts (already hash-pinned)

Two scripts fetch code/data at run time on a live system; both already pin
a sha256 and abort before use on mismatch — the `--require-hashes` property
in shell form, no change needed:

- `config/includes.chroot/usr/local/bin/dogos-ai-setup` — downloads the
  Ollama installer from `https://ollama.com/install.sh`, verifies it
  against a pinned `OLLAMA_INSTALL_SHA256` (pinned 2026-10-11), and only
  then executes it. Model pulls after that are Ollama's own channel.
- `config/includes.chroot/usr/share/dogos/osint/fetch-seclists.sh` —
  downloads the SecLists tarball for a pinned upstream commit
  (`SECLISTS_COMMIT`), verifies `SECLISTS_SHA256`, and only then extracts.

## 5. What is NOT here

- No `requirements*.txt`, `pyproject.toml`, `package.json`, or any other
  pip/npm input anywhere in the tree (static grep, 2026-10-25).
- No hash lock is added by this change, because there is no pip-style
  install for one to lock. If a pip surface is ever added, it must land
  together with its `*.lock.txt` (`pip install --require-hashes`), per the
  fleet policy this file records.

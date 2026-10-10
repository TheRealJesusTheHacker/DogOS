# dogos-extras — DogOS signed APT repository

Holds everything DogOS needs that Debian doesn't ship: the LOIC fork
(post-audit), repackaged pip tools (hash-pinned, vendored wheels), and the
`dogos-*` helper scripts as proper packages.

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

## Client config (ships in the DogOS image via live-build includes)
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
- REJECTED 2026-10-10: LOIC — audit found no maintained port; see design spec
- Queued: holehe, maigret, sherlock, snscrape, shodan (pip → vendored, hash-pinned)
- Queued: phoneinfoga, onionscan, photon, ghunt, blackbird (manual builds)
- Queued: feather-wallet, yggdrasil, retroshare (upstream debs, mirrored+verified)
- Candidates (modern stress tools, replacing LOIC): T50, slowloris, Anevicon

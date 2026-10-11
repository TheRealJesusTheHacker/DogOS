# Security Policy

## Reporting a vulnerability

**Do not open a public issue for a security vulnerability.** Email the
details to **Sentinelsafeguard@outlook.com** with:

- A description of the issue and what you think the impact is
- Steps to reproduce (commands, config, or a minimal example)
- The affected file(s) and, if you know it, the commit

Reports are read by the maintainer. You'll get an acknowledgment, and the
fix will be discussed before anything is disclosed publicly.

## Scope

DogOS is currently in the scaffold stage (v0.1.0 prerelease — project
source, no bootable ISO yet). In-scope for reports:

- The `dogos-*` helper scripts (`dogos-ghost`, `dogos-engage`,
  `dogos-leaktest`, `dogos-ai-setup`, `dogos-hostname`)
- The live-build hooks and `auto/config`
- The `dogos-extras` repo tooling
- Anonymity claims (e.g. a leak path Ghost mode doesn't cover)

## Threat model

DogOS is an *attack* distro — it assumes the operator is the trusted party
working from potentially hostile networks. It protects:

- Operator anonymity (Ghost mode, amnesiac live boot, MAC randomization)
- Data at rest (LUKS via the installer)
- Toolkit integrity (signed repos, checksummed ISOs)

It does **not** claim to defend against physical seizure of an unlocked
machine, operator OPSEC failures, or targeted endpoint compromise by a
well-resourced adversary. Reports that fall outside this threat model will
still be read, but may be closed as out of scope.

There is no bug-bounty program; credit is given in the changelog on request.

## What this PR does

## Checklist

- [ ] `bash -n` passes on every touched shell script
- [ ] shellcheck is clean on every touched shell script (`-S warning`)
- [ ] No `dogos-*` CLI contracts changed (or the change is called out below)
- [ ] No feature stripped or neutered to satisfy a check — issues are fixed
      *around* intended functionality, or documented and left as-is
- [ ] Package-list changes: names verified against the live Debian/Kali
      archive (`apt-cache policy`)
- [ ] Docs updated if behavior changed (README, design spec, flavor notes)

## Notes for reviewers

Anything that needs a second look — trade-offs, intentional TODOs, or
findings documented-and-left.

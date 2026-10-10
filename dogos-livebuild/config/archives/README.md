# Kali archive — WIRED (2026-10-10)
#
# - Source:  kali.list.chroot -> https://http.kali.org/kali kali-rolling
# - Keyring: kali-archive-keyring.key.chroot, extracted from the official
#   kali-archive-keyring_2025.3_all.deb (latest in the pool on 2026-10-10).
#
# FINGERPRINT VERIFICATION (do not skip on future keyring updates):
#   Contained keys (gpg --show-keys):
#     827C8569F2518CC677FECA1AED65462EC8D5E4C5  -> Kali 2025 archive signing key
#         matches Kali's published 2025 key (post-April-2025 key-loss rotation;
#         reported by Kali's blog and widely documented)
#     44C6513A8E4FB3D30875F758ED444FF07D8D0BF6  -> pre-2025 archive key
#         matches the long-published Kali key (Kali Linux Revealed, etc.)
#     0D7685430E29EEBBBDFD6FE7A8373E18FC0D0DCB  -> present in keyring,
#         NOT independently verified; kept for signature compat, treat as untrusted
#         until verified against a Kali-published value.
#
# Pinning: none yet. kali-tools-* metapackages exist only in Kali, so no
# Debian conflicts today. Add kali.pref.chroot if a future conflict appears.

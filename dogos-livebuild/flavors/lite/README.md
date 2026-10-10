# DogOS flavor overlays.
#
# live-build reads a single config tree, so flavors work by overlay:
#   build.sh full  -> uses config/ as-is (kitchen sink, ~10-11 GB ISO)
#   build.sh lite  -> overlays flavors/lite/ onto a copy of the tree
#                     (top10 essentials, ~4-5 GB ISO)
#
# flavors/lite/ mirrors the config/ layout: any file placed here replaces
# the same path under config/ in the assembled build dir.
# To change what lite ships, edit flavors/lite/config/package-lists/.
#
# The DogOS OSINT, anonymity and AI layers ship in BOTH flavors —
# lite is still a complete recon distro, just without the long tail
# of Kali metapackages.

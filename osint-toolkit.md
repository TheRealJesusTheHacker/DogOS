# DogOS OSINT Toolkit — candidate inventory

_Compiled 2026-10-10. Skyler's direction: "as many OSINT resources as we can."
Status markers: [packaged] = in Debian/Kali repos or pip-installable; [service] = web service / bookmark pack;
[manual] = needs manual install / git clone. Verify availability before baking into the ISO._

## Design notes
- DogOS ships three layers: (1) installable tools, (2) a curated **bookmark pack** for the default
  browser (web-only services), (3) an **API-key template dir** (`~/.config/dogos/osint/keys.env.template`)
  since half of OSINT runs on API keys (Shodan, Censys, Hunter.io, etc.).
- Add a dedicated **"OSINT" category** in the MATE applications menu.
- Ship a starter **wordlists + dork-lists** dir (`/usr/share/dogos/osint/`): Google dorks (GHDB),
  subdomain wordlists, username lists.

## Username / identity enumeration
- Sherlock [packaged/pip] — username search across hundreds of sites
- Maigret [pip] — Sherlock successor, more sources
- WhatsMyName [manual] — username enumeration web tool / dataset
- Blackbird [pip] — fast username search
- Namechk [service] — username availability across platforms

## Email
- theHarvester [packaged] — emails, subdomains, hosts from public sources
- Holehe [pip] — check if email is attached to accounts on 120+ sites
- Ghunt [pip] — Google-account OSINT (requires cookies/creds)
- Hunter.io [service] — find/verify professional emails (API)
- Epieos [service] — email/phone reverse lookup
- VoilaNorbert [service] — email finder/verifier (API)

## Domain / subdomain / DNS
- Amass [packaged] — attack-surface mapping, subdomain enum
- Subfinder [packaged] — passive subdomain discovery
- Sublist3r [packaged] — subdomain enumeration
- Assetfinder [manual] — find domains/subdomains related to a target
- Findomain [manual] — fast subdomain enumerator
- dnstwist [pip] — domain permutation / typosquat detection
- DNSRecon [packaged] — DNS enumeration scripting
- DNSenum [packaged] — DNS information gathering
- fierce [packaged] — DNS reconnaissance
- crt.sh [service] — certificate-transparency subdomain search
- SecurityTrails [service] — historical DNS / domain intel (API)
- Whois [packaged] — domain registration data

## IP / network / infrastructure
- Shodan CLI [pip] — search engine for internet-connected devices (API)
- Censys [service] — internet-wide scan data (API)
- BinaryEdge [service] — internet intelligence platform (API)
- GreyNoise [service] — internet background-noise / threat intel (API)
- VirusTotal [service] — file/URL/IP reputation (API)
- AbuseIPDB [service] — IP abuse reports (API)
- urlscan.io [service] — website scan / screenshot intel (API)
- BuiltWith [service] — technology profiler for websites
- Wappalyzer [service/browser ext] — tech-stack detection
- Netlas [service] — internet intelligence (API)

## People search (bookmark pack — mostly web services)
- WebMii, PeekYou, TruePeopleSearch, That's Them, FastPeopleSearch [service]
- Pipl [service, paid] — identity resolution
- Social Searcher [service] — social mentions

## Social media
- snscrape [pip] — scrape social platforms (Twitter/X, Instagram, etc.)
- Instaloader [pip] — download Instagram profiles/posts/metadata
- Twint [manual, deprecated — X/Twitter API changes killed it; keep for historical data?]
- Telegram scraping via Telethon [pip] — channel/group OSINT
- Social Blade [service] — social stats
- Picuki / Imginn [service] — anonymous Instagram viewers

## Breach / leak data
- HaveIBeenPwned [service] — breach exposure check (API)
- DeHashed [service, paid] — breach database search (API)
- Intelligence X [service] — data-breach / leak search (API)
- LeakCheck [service] — breach lookup (API)
- Snusbase [service, paid] — breach database (API)

## Web / content recon
- Photon [manual] — fast web crawler for OSINT
- waybackpy [pip] / Wayback Machine [service] — historical page captures
- GHDB / Google dorks [resource list] — advanced search operators
- Metagoofil [packaged] — document metadata extraction from public docs
- ExifTool [packaged] — image/file metadata
- theHarvester (see Email) — also harvests from search engines

## Geospatial / imagery / transport
- Google Earth / Maps [service] — satellite & street-level imagery
- Sentinel Hub [service] — satellite imagery (API)
- Wigle.net [service] — wireless network geolocation (API)
- ADS-B Exchange [service] — unfiltered flight tracking
- Flightradar24 [service] — flight tracking
- MarineTraffic [service] — vessel tracking
- Pic2Map / EXIF geolocation workflow [methodology]

## Phone numbers
- PhoneInfoga [manual] — phone-number OSINT (carrier, VOIP, footprints)

## Dark web
- Tor Browser [packaged] — .onion access
- Ahmia [service] — onion search engine
- OnionScan [manual] — scan onion services for operational-security leaks

## Frameworks / aggregators
- Recon-ng [packaged] — modular recon framework
- SpiderFoot [packaged] — automated OSINT collection
- Maltego CE [manual] — link analysis / entity graphing
- OSINT Framework [service] — the master directory of OSINT resources (bookmark #1)

## Open questions
- Which paid-API services (if any) do we pre-wire vs. leave as templates?
- Twint: drop (dead) or keep for historical X/Twitter datasets?
- Package the bookmark pack as a Firefox policy/bookmarks file or a start-page portal?

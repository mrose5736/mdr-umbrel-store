# MDR Cloud Apps: an Umbrel community app store

Apps packaged for [umbrelOS](https://umbrel.com). Add this store in umbrelOS under **App Store → ⋯ → Community App Stores** with the URL of this repository.

| App | What it is |
|---|---|
| **MDR-NEXUS** (`mdr-nexus`) | A self-hosted, read-only personal API gateway: your accounts as one API with scoped keys, plus a dashboard. |

This repository holds only packaging (manifest, compose file, secret derivation). The container image is `ghcr.io/mrose5736/mdr-nexus`; its compose reference is rewritten automatically by the Nexus CI on every release, so **do not edit the `image:` line or `version` by hand**.

## MDR-NEXUS on Umbrel

**Install:** open the app in the store and press Install. Umbrel shows the app's password; sign in to Nexus with it (the portal is also behind your Umbrel login). The app listens on port `8795`.

**Public address:** point your Cloudflare Tunnel's public hostname `nexus.mdr95.net` at `http://<umbrel-ip>:8795`. The hostname is set in the compose file as `NEXUS_BASE_URL` and must match the redirect URIs registered with Google, Spotify and the other OAuth providers.

**OAuth secrets (optional).** Pasted-key connectors (GitHub, Steam, Octopus, Xbox, MDRCloud, Mixcloud, TruckersMP) work straight away. For "Sign in with…" connectors, create `~/umbrel/app-data/mdr-nexus/data/nexus.env` over SSH, one setting per line, then restart the app:

```
NEXUS_GOOGLE_CLIENT_ID=...
NEXUS_GOOGLE_CLIENT_SECRET=...
NEXUS_SPOTIFY_CLIENT_ID=...
NEXUS_SPOTIFY_CLIENT_SECRET=...
```

The names are listed in the Nexus documentation (`NEXUS_MS_`, `NEXUS_GOOGLE_`, `NEXUS_DISCORD_`, `NEXUS_SPOTIFY_`, `NEXUS_REDDIT_`, `NEXUS_TWITCH_`, each with `CLIENT_ID` and `CLIENT_SECRET`). This file is never committed anywhere.

**What stays public through Umbrel's login:** `/v1/*` (API keys do the authentication), `/docs/*`, `/openapi*`, `/schemas/*`, `/healthz` and the OAuth sign-in endpoints (`/admin/api/oauth/*`; starting a sign-in still needs the Nexus admin session).

**Backups:** a container writes a database dump into `~/umbrel/app-data/mdr-nexus/data/backups` every 24 hours and keeps 14 days. Restore with:

```bash
cd ~/umbrel/app-data/mdr-nexus
docker exec -i mdr-nexus_db_1 pg_restore -U nexus -d nexus --clean --if-exists < data/backups/nexus-YYYYMMDD-HHMMSS.dump
```

**Secrets are derived, not stored here.** The database password and the key that encrypts your connector credentials are derived from your Umbrel's seed (`exports.sh`). Restoring the same Umbrel seed restores the same keys; a different seed cannot decrypt old connector credentials (you would re-add them).

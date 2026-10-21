# Deployment

DayCommit runs on the OVHcloud VPS as a Docker container. Every push to `main` builds a new image and deploys it.

## How it works

```
browser ──HTTPS──▶ edge proxy (Caddy, ports 80/443, TLS) ──HTTP──▶ daycommit-web:80 (Caddy, static files)
```

- **`deploy/web/Dockerfile`**: a multi-stage build. Stage 1 runs `npm ci` and `npm run build` in Node. Stage 2 copies only `dist/` into a small Caddy image. It also writes the commit SHA (the Git commit id) to `/version.txt`.
- **`deploy/web/Caddyfile`**: serves the built files over plain HTTP inside Docker. Hashed files under `/assets` are cached for a year; `index.html` is revalidated on every load; unknown paths fall back to `index.html`.
- **`deploy/compose.yaml`**: runs the image as the `web` service. It publishes no ports and joins the shared `edge` Docker network as `daycommit-web`.
- **`deploy/remote-deploy.sh`**: runs on the VPS over SSH. It pulls the new image and restarts the container.
- **`.github/workflows/deploy.yml`**: on push to `main`, builds the image, pushes it to GHCR (GitHub Container Registry) as `ghcr.io/d-luga/daycommit-web:<sha>`, deploys it, and checks that `https://daycommit.com/version.txt` shows the new SHA.
- **`.github/workflows/ci.yml`**: on every pull request, runs lint and build.

The app container doesn't handle TLS or domains. Only one process on the server can listen on ports 80 and 443, so a single edge proxy does that for every project on the VPS.

## Edge proxy config

The edge proxy needs these blocks for DayCommit:

```caddyfile
daycommit.com {
	header Strict-Transport-Security "max-age=86400"
	reverse_proxy daycommit-web:80
}

www.daycommit.com, daycommit.net, www.daycommit.net {
	redir https://daycommit.com{uri} permanent
}
```

The edge container must join the `edge` network too.

## One-time setup

On the VPS:

```bash
docker network create edge
sudo install -d -o deploy -g deploy /srv/daycommit
```

DNS at OVH: A records for `daycommit.com`, `www.daycommit.com`, `daycommit.net` and `www.daycommit.net`, pointing to the VPS.

In the GitHub repository settings:

- Environment `production`, with secrets `DEPLOY_SSH_KEY` (private key of the `deploy` user) and `DEPLOY_KNOWN_HOSTS` (output of `ssh-keyscan` for the VPS).

## Check what is live

```bash
curl https://daycommit.com/version.txt
```

#!/usr/bin/env bash
# Runs on the VPS as the deploy user. Expects WEB_IMAGE in the environment.
set -euo pipefail

cd /srv/daycommit

printf 'WEB_IMAGE=%s\n' "$WEB_IMAGE" > .env

docker compose pull
docker compose up -d --remove-orphans
docker image prune -af --filter "until=168h"
docker logout ghcr.io

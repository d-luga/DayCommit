# Stage 1: build the app with Node.
FROM node:22-alpine AS build
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build

# Stage 2: serve the built files with Caddy. Only dist/ is copied,
# so Node, node_modules and the source code stay out of the final image.
FROM caddy:2.10-alpine

COPY deploy/web/Caddyfile /etc/caddy/Caddyfile
COPY --from=build /app/dist/ /srv/site/

RUN caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile

ARG GIT_SHA=dev
RUN echo "$GIT_SHA" > /srv/site/version.txt

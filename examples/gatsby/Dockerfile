FROM python:3.11-bullseye AS build

ENV DEBIAN_FRONTEND=noninteractive

RUN <<EOF
#!/usr/bin/env bash
set -euxo pipefail

# install nodejs 18 and yarn
curl -sL https://deb.nodesource.com/setup_18.x | bash -
apt update
apt upgrade -y
apt install -y \
    nodejs \
    && npm install -g yarn \
    && rm -rf /var/lib/apt/lists/*

EOF

WORKDIR /usr/src/app

COPY . .

RUN <<EOF
#!/usr/bin/env bash
set -euxo pipefail

# install dependencies
yarn

# disable telemetry
yarn global add gatsby-cli && gatsby telemetry --disable

# TODO: npx update-browserslist-db@latest

# build
yarn build

EOF

# * QA-only
# CMD [ "sleep", "infinity" ]
# CMD [ "bash", "-c", "sleep infinity" ]

FROM node:18-bullseye-slim AS server

WORKDIR /usr/src/app
COPY --from=build /usr/src/app/public .
COPY --from=build /usr/src/app/node_modules ./node_modules

EXPOSE 8000

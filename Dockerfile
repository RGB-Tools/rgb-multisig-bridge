FROM rust:1.93-slim-trixie AS builder

COPY . .

RUN cargo build --release


FROM debian:trixie-slim

RUN apt-get update && apt install -y --no-install-recommends \
    curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=builder ./target/release/rgb-multisig-bridge /usr/bin/rgb-multisig-bridge

WORKDIR /srv
VOLUME ["/srv/data"]
EXPOSE 3001/tcp

HEALTHCHECK CMD curl localhost:3001 || exit 1

ENTRYPOINT ["/usr/bin/rgb-multisig-bridge"]
CMD ["/srv/data"]

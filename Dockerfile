FROM debian:bookworm-slim AS builder
WORKDIR /source

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y install \
    build-essential pkg-config erlang erlang-reltool \
    libicu-dev libmozjs-78-dev python3 \
    git ca-certificates nodejs npm \
    python3.11-venv

COPY . .
RUN ./configure --spidermonkey-version=78
RUN make release

FROM debian:bookworm-slim AS runner
WORKDIR /opt/couchdb

RUN apt-get update && \
    apt-get -y install \
    erlang openssl python3
    
RUN adduser --system \
  --home /opt/couchdb \
  --no-create-home \
  --shell /bin/bash \
  --group --gecos \
  "CouchDB Administrator" couchdb

COPY --from=builder --chown=couchdb:couchdb /source/rel/couchdb .

VOLUME ["/opt/couchdb/data"]

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

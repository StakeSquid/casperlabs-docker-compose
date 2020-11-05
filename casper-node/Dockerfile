FROM ubuntu:latest

RUN apt update -y  && apt install -y wget coreutils

RUN wget --content-disposition https://github.com/CasperLabs/casper-node/releases/download/v1.6.0/casper-client_1.6.0-2465_amd64.deb
RUN wget --content-disposition https://github.com/CasperLabs/casper-node/releases/download/v1.6.0/casper-node_1.6.0-2465_amd64.deb

RUN apt install -y ./casper-client_1.6.0-2465_amd64.deb ./casper-node_1.6.0-2465_amd64.deb

VOLUME /etc/casper/validator_keys

RUN rm /etc/casper/config.toml
VOLUME /etc/casper/config.toml

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["validator" "/etc/casper/config.toml"]
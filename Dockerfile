FROM ubuntu:latest

RUN apt update -y  && apt install -y wget coreutils

RUN wget --content-disposition https://bintray.com/casperlabs/debian/download_file?file_path=casper-client_1.5.0-2267_amd64.deb
RUN wget --content-disposition https://bintray.com/casperlabs/debian/download_file?file_path=casper-node_1.5.0-2267_amd64.deb

RUN apt install -y ./casper-client_1.5.0-2267_amd64.deb ./casper-node_1.5.0-2267_amd64.deb

VOLUME /etc/casper/validator_keys

RUN rm /etc/casper/config.toml
VOLUME /etc/casper/config.toml

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["validator" "/etc/casper/config.toml"]
FROM rust:latest


RUN git clone https://github.com/CasperLabs/casper-node.git && cd casper-node && git checkout v1.6.0 && make setup-rs

CMD ["bash"]
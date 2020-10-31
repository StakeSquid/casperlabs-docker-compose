FROM rust:latest


RUN git clone https://github.com/CasperLabs/casper-node.git && cd casper-node && git checkout v1.5.0 && make setup-rs

CMD ["bash"]
FROM rust:latest


RUN git clone https://github.com/CasperLabs/casper-node.git && cd casper-node && git checkout 8f2eb44073 && make setup-rs

CMD ["bash"]
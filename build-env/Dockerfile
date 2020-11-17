FROM rust:latest


RUN git clone https://github.com/CasperLabs/casper-node.git && cd casper-node && git checkout master && make setup-rs

CMD ["bash"]
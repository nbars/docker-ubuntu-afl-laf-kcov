
FROM ubuntu:16.04

RUN apt update && apt install git libasan2 build-essential cmake pkg-config screen libc6-dev-i386 clang valgrind bsdmainutils binutils-dev libcurl4-openssl-dev zlib1g-dev libdw-dev libiberty-dev -y

#Install afl & laf
RUN mkdir -p /tmp/afl \
    && cd /tmp/afl \
    && git clone https://github.com/mirrorer/afl.git afl \
    && git clone https://gitlab.com/laf-intel/laf-llvm-pass.git laf \
    && cd afl \
    && make \
    && cd llvm_mode \
    && cp ../../laf/src/*.so.cc . \
    && cp ../../laf/src/afl.patch . \
    && patch < afl.patch \
    && export LLVM_CONFIG=/usr/bin/llvm-config-3.8 \
    && make \
    && cd .. \
    && make install \
    && cp compare-transform-pass.so /usr/local/lib/afl/ \
    && cp split-compares-pass.so /usr/local/lib/afl/ \
    && cp split-switches-pass.so /usr/local/lib/afl/


#Install kcov
RUN cd /tmp \
    && git clone https://github.com/SimonKagstrom/kcov.git kcov \
    && cd kcov \
    && git checkout 69c598b2c136b7c80d02acad012af689241afc5f \
    && cmake . \
    && make \
    && make install

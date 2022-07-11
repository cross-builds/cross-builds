FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt install -y --no-install-recommends \
       ca-certificates curl vim clang lld  \
       xz-utils libtinfo5

ENV WORKDIR=root/llvmwasm

RUN mkdir $WORKDIR
WORKDIR $WORKDIR

COPY testbuild testbuild

RUN clang \
    --target=wasm32 \
    -O3 \
    -flto \
    -nostdlib \
    -Wl,--no-entry \
    -Wl,--export-all \
    -Wl,--lto-O3 \
    -o testbuild/fib.wasm \
    testbuild/fib.c

RUN curl https://get.wasmer.io -sSfL | sh
RUN /root/.wasmer/bin/wasmer testbuild/fib.wasm -i fib 15

RUN curl -L -O https://github.com/WebAssembly/wasi-libc/releases/download/v0.1-alpha/wasi-sysroot.tar.xz \
    && tar -xvf wasi-sysroot.tar.xz

RUN curl -L -O https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-16/libclang_rt.builtins-wasm32-wasi-16.0.tar.gz \
    && tar -xvf libclang_rt.builtins-wasm32-wasi-16.0.tar.gz \
    && cp -r lib/* /usr/lib/clang/14.0.0/lib/

RUN clang \
    --target=wasm32-wasi \
    --sysroot=sysroot/ \
    --rtlib=compiler-rt \
    -O3 \
    -flto \
    -Wl,--export-all \
    -Wl,--lto-O3 \
    -o testbuild/hello.wasm \
    testbuild/hello.c

RUN /root/.wasmer/bin/wasmer testbuild/hello.wasm
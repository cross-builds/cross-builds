FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV GCC_VERS=12

# Set the working directory to root (ie $HOME)
WORKDIR root

RUN apt-get update \
    && apt install -y --no-install-recommends \
               cmake ninja-build llvm-dev clang lld libc++-dev \
               libc++abi-dev zlib1g-dev git build-essential \
               ca-certificates crossbuild-essential-arm64 \
               libstdc++-$GCC_VERS-dev-arm64-cross qemu-user

RUN cd \
    && mkdir -p sysroots/aarch64-linux-gnu/usr \
    && cd sysroots/aarch64-linux-gnu/usr \
    && cp -r -v -L /usr/aarch64-linux-gnu/include /usr/aarch64-linux-gnu/lib . \
    && cd lib \
    && cp -r -v -L /usr/lib/gcc-cross/aarch64-linux-gnu/$GCC_VERS/*gcc* . \
    && cp -r -v -L /usr/lib/gcc-cross/aarch64-linux-gnu/$GCC_VERS/*crt* . \
    && cp -r -v -L /usr/lib/gcc-cross/aarch64-linux-gnu/$GCC_VERS/libsupc++.a . \
    && cp -r -v -L /usr/lib/gcc-cross/aarch64-linux-gnu/$GCC_VERS/libstdc++*  . \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

COPY testFiles testFiles

ENV TARGET_TRIPLE=aarch64-unknown-linux-gnu

RUN mkdir aarch64_bin \
    && clang \
    --target=$TARGET_TRIPLE  \
    --sysroot=$HOME/sysroots/aarch64-linux-gnu \
    -fuse-ld=lld \
    testFiles/hello.c \
    -o aarch64_bin/hello_c.out

RUN clang++ \
    --target=$TARGET_TRIPLE  \
    --sysroot=$HOME/sysroots/aarch64-linux-gnu \
    -fuse-ld=lld \
    testFiles/hello.cpp \
    -o aarch64_bin/hello_cpp.out

RUN qemu-aarch64 -L sysroots/aarch64-linux-gnu/usr/ ./aarch64_bin/hello_c.out
RUN qemu-aarch64 -L sysroots/aarch64-linux-gnu/usr/ ./aarch64_bin/hello_cpp.out

RUN git clone https://github.com/farzonl/prompt.git

RUN cmake -GNinja -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
          -DCMAKE_ASM_COMPILER=clang \
          -DCMAKE_INSTALL_PREFIX=/ \
          -DCMAKE_SYSROOT=$HOME/sysroots/aarch64-linux-gnu \
          -DCMAKE_C_COMPILER_TARGET=$TARGET_TRIPLE \
          -DCMAKE_CXX_COMPILER_TARGET=$TARGET_TRIPLE \
          -DCMAKE_ASM_COMPILER_TARGET=$TARGET_TRIPLE \
          -DCMAKE_C_FLAGS="-fuse-ld=lld" \
          -DCMAKE_CXX_FLAGS="-fuse-ld=lld" \
          -S "prompt/WordFreq" \
          -B "aarch64_bin/WordFreq"

RUN ninja -C./aarch64_bin/WordFreq

RUN cmake -GNinja -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
          -DCMAKE_ASM_COMPILER=clang \
          -DCMAKE_INSTALL_PREFIX=/ \
          -DCMAKE_SYSROOT=$HOME/sysroots/aarch64-linux-gnu \
          -DCMAKE_C_COMPILER_TARGET=$TARGET_TRIPLE \
          -DCMAKE_CXX_COMPILER_TARGET=$TARGET_TRIPLE \
          -DCMAKE_ASM_COMPILER_TARGET=$TARGET_TRIPLE \
          -DCMAKE_C_FLAGS="-fuse-ld=lld" \
          -DCMAKE_CXX_FLAGS="-fuse-ld=lld" \
          -S "prompt/TowerOfHanoi" \
          -B "aarch64_bin/TowerOfHanoi"

RUN ninja -C./aarch64_bin/TowerOfHanoi

RUN qemu-aarch64 -L sysroots/aarch64-linux-gnu/usr/ aarch64_bin/WordFreq/src/WordFreq testFiles/fox.txt
RUN qemu-aarch64 -L sysroots/aarch64-linux-gnu/usr/ aarch64_bin/WordFreq/test/WordFreq_TEST
RUN qemu-aarch64 -L sysroots/aarch64-linux-gnu/usr/ aarch64_bin/TowerOfHanoi/src/TowerOfHanoi 3 -print_state
RUN qemu-aarch64 -L sysroots/aarch64-linux-gnu/usr/ aarch64_bin/TowerOfHanoi/test/TowerOfHanoi_TEST 
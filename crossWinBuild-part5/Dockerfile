From ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt install -y \
    clang lld lldb llvm-dev libclang-dev wget curl \
    ca-certificates zip unzip vim jq wine \
    msitools p7zip-full

ENV DEBIAN_FRONTEND=dialog
ENV WORKDIR=root/project
RUN mkdir $WORKDIR

#Set the working dir to the env variable
WORKDIR $WORKDIR

COPY testBuild testBuild

#COPY win_sysroot.zip win_sysroot.zip
#RUN unzip win_sysroot.zip

#Note if we unzip we don't need to download on the docker image
SHELL ["/bin/bash", "-c"]
RUN testBuild/download_win_sysroot.sh

RUN testBuild/vfs_overlay.sh


# We should not need to do this vfs_overlay should handle naming issues.
# However it isn't working so this is a brute force solution

RUN python3 testBuild/rename.py win_sysroot



RUN testBuild/build-x86.sh

RUN testBuild/build-x64.sh

# To get wine to run 32 and 64 bit binaries you have to do the install in stages
RUN dpkg --add-architecture i386
RUN apt-get update \
    && apt install -y \
    wine32

RUN wine testBuild/hello-x64.exe

RUN wine testBuild/hello-32.exe



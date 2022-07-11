MSVC_VERSION=14.11.25547
WIN_SDK_VERSION=10.0.22621.0

clang -target i686-pc-win32 \
  -fms-compatibility-version=19 \
  -fms-extensions \
  -fdelayed-template-parsing \
  -fexceptions \
  -mthread-model posix \
  -fno-threadsafe-statics \
  -Wno-msvc-not-found \
  -DWIN32 \
  -D_WIN#@ \
  -D_MT \
  -D_DLL \
  -Xclang -disable-llvm-verifier \
  -Xclang -ivfsoverlay \
  -Xclang $PWD/winsdk_vfs_overlay.yaml \
  -Xclang '--dependent-lib=msvcrt' \
  -Xclang '--dependent-lib=ucrt' \
  -Xclang '--dependent-lib=oldnames' \
  -Xclang '--dependent-lib=vcruntime' \
  -D_CRT_SECURE_NO_WARNINGS \
  -D_CRT_NONSTDC_NO_DEPRECATE \
  -U__GNUC__ \
  -U__gnu_linux__ \
  -U__GNUC_MINOR__ \
  -U__GNUC_PATCHLEVEL__ \
  -U__GNUC_STDC_INLINE__ \
  -I /user/include/llvm \
  -I win_sysroot/MSVC/$MSVC_VERSION/include \
  -I win_sysroot/WINSDK/$WIN_SDK_VERSION/include/um \
  -I win_sysroot/WINSDK/$WIN_SDK_VERSION/include/ucrt \
  -I win_sysroot/WINSDK/$WIN_SDK_VERSION/include/shared \
  -I win_sysroot/WINSDK/$WIN_SDK_VERSION/include/winrt \
  -c testBuild/hello.c -o testBuild/hello-32.o

clang -fuse-ld=lld -target i686-pc-win32 \
  -Wl,-machine:x86 -fmsc-version=1900 \
  -o testBuild/hello-32.exe testBuild/hello-32.o \
  -L win_sysroot/MSVC/$MSVC_VERSION/lib/x86 \
  -L win_sysroot/WINSDK/$WIN_SDK_VERSION/lib/um/x86 \
  -L win_sysroot/WINSDK/$WIN_SDK_VERSION/lib/ucrt/x86 \
  -nostdlib -lmsvcrt -Wno-msvc-not-found


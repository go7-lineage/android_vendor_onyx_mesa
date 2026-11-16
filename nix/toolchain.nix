{
  runCommand,
  fetchgit,
  llvmPackages_22,
  pkgsCross,
  emptyDirectory,
}:
let
  triple = "aarch64-linux-android";
  api = "31";
  bionic = pkgsCross.aarch64-android.bionic;

  aosp =
    fetchgit {
      url = "https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86";
      rev = "29182889399818f97baa65ea238c80e8117981eb";
      sparseCheckout = map (p: "clang-r596125/${p}") [
        "include/c++/v1"
        "android_libc++/ndk/aarch64"
        "runtimes_ndk_cxx/aarch64"
        "lib/clang/22/lib/linux/libclang_rt.builtins-aarch64-android.a"
      ];
      nonConeMode = true;
      hash = "sha256-LLKh563jHyV0S0UoQMnPnLyDPagHm3Nin6XI33qIwms=";
    }
    + "/clang-r596125";
  ndk = "${aosp}/android_libc++/ndk/aarch64";
in
runCommand "android-arm64-toolchain" { } ''
  inc=$out/sysroot/usr/include
  lib=$out/sysroot/usr/lib/${triple}
  mkdir -p $inc/c++ $lib/${api} $out/resource/lib/linux

  cp -r ${bionic.dev}/include/. $inc/
  cp ${bionic}/lib/* $lib/${api}/

  cp -r ${aosp}/include/c++/v1 $inc/c++/
  chmod -R u+w $inc
  cp --remove-destination ${ndk}/include/c++/v1/__config_site $inc/c++/v1/
  cp ${ndk}/lib/libc++_static.a ${ndk}/lib/libc++abi.a ${aosp}/runtimes_ndk_cxx/aarch64/libunwind.a $lib/
  echo 'INPUT(-lc++_static -lc++abi)' > $lib/libc++.a

  cp -r ${llvmPackages_22.clang-unwrapped.lib}/lib/clang/22/include $out/resource/
  cp ${aosp}/lib/clang/22/lib/linux/*.a $out/resource/lib/linux/

  substitute ${./cross.ini} $out/cross.ini \
    --subst-var-by target ${triple}${api} \
    --subst-var-by sysroot $out/sysroot \
    --subst-var-by resource $out/resource \
    --subst-var-by empty ${emptyDirectory}
''

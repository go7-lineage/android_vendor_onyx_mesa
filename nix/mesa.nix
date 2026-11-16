{
  stdenv,
  callPackage,
  mesa,
  llvmPackages_22,
  meson,
  ninja,
  pkg-config-unwrapped,
  bison,
  flex,
  glslang,
  patchelf,
  python3,
}:
let
  toolchain = callPackage ./toolchain.nix { };
  subprojects = callPackage ./subprojects.nix { };

  options = [
    "--cross-file=${toolchain}/cross.ini"
    "--wrap-mode=nodownload"
    "--force-fallback-for=zlib,expat,libdrm"
    "-Dallow-fallback-for=libdrm"
    "-Dbuildtype=release"
    "-Dplatforms=android"
    "-Dplatform-sdk-version=34"
    "-Dandroid-stub=true"
    "-Dandroid-libbacktrace=disabled"
    "-Dgallium-drivers=freedreno"
    "-Dvulkan-drivers=freedreno"
    "-Dfreedreno-kmds=msm"
    "-Degl=enabled"
    "-Dgles1=enabled"
    "-Dgles2=enabled"
    "-Degl-lib-suffix=_mesa"
    "-Dgles-lib-suffix=_mesa"
    "-Dgbm=disabled"
    "-Dglx=disabled"
    "-Dllvm=disabled"
    "-Dzstd=disabled"
  ];
in
stdenv.mkDerivation {
  name = "mesa-android-arm64-${mesa.version}";

  nativeBuildInputs = [
    llvmPackages_22.clang-unwrapped
    llvmPackages_22.lld
    llvmPackages_22.llvm
    meson
    ninja
    pkg-config-unwrapped
    bison
    flex
    glslang
    patchelf
    (python3.withPackages (
      ps: with ps; [
        mako
        pyyaml
        packaging
        ply
      ]
    ))
  ];

  # Mesa's generator for the ir3 instruction encoder orders its output by Python's string hashes
  PYTHONHASHSEED = "0";

  buildCommand = ''
    cp -r ${mesa.src} src
    chmod -R u+w src
    ln -s ${subprojects} src/subprojects/packagecache
    meson setup build src ${toString options}
    meson compile -C build -j $NIX_BUILD_CORES

    mkdir $out
    cp build/src/egl/libEGL_mesa.so $out/
    cp build/src/mesa/glapi/es1api/libGLESv1_CM_mesa.so $out/
    cp build/src/mesa/glapi/es2api/libGLESv2_mesa.so $out/
    cp build/src/gallium/targets/dri/libgallium_dri.so $out/
    cp build/src/freedreno/vulkan/libvulkan_freedreno.so $out/vulkan.freedreno.so
    patchelf --set-soname vulkan.freedreno.so $out/vulkan.freedreno.so
    for f in $out/*.so; do patchelf --remove-rpath $f; done
    llvm-strip --strip-unneeded $out/*.so
  '';
}

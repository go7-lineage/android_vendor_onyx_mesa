{
  fetchurl,
  linkFarm,
}:
let
  wrapdb = "https://github.com/mesonbuild/wrapdb/releases/download";
  patch = name: "https://wrapdb.mesonbuild.com/v2/${name}/get_patch";
in
linkFarm "mesa-packagecache" (
  map
    (file: {
      inherit (file) name;
      path = fetchurl file;
    })
    [
      {
        name = "zlib-1.3.1.tar.gz";
        url = "${wrapdb}/zlib_1.3.1-1/zlib-1.3.1.tar.gz";
        sha256 = "9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23";
      }
      {
        name = "zlib_1.3.1-1_patch.zip";
        url = patch "zlib_1.3.1-1";
        sha256 = "e79b98eb24a75392009cec6f99ca5cdca9881ff20bfa174e8b8926d5c7a47095";
      }
      {
        name = "expat-2.5.0.tar.bz2";
        url = "${wrapdb}/expat_2.5.0-3/expat-2.5.0.tar.bz2";
        sha256 = "ef2420f0232c087801abf705e89ae65f6257df6b7931d37846a193ef2e8cdcbe";
      }
      {
        name = "expat_2.5.0-3_patch.zip";
        url = patch "expat_2.5.0-3";
        sha256 = "e30c8c32f79fd4563a86a5c9cfe419568c35b775077c2d1428170081129406b4";
      }
      {
        name = "libdrm-2.4.123.tar.xz";
        url = "https://dri.freedesktop.org/libdrm/libdrm-2.4.123.tar.xz";
        sha256 = "a2b98567a149a74b0f50e91e825f9c0315d86e7be9b74394dae8b298caadb79e";
      }
    ]
)

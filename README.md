# android_vendor_onyx_mesa

Mesa freedreno (GLES) and turnip (Vulkan) drivers for the Boox Go 7 on LineageOS

`prebuilt/` is the unmodified output of `nix build && install -m 644 result/*.so prebuilt/`. It is committed so that building Android wouldn't need Nix or a Mesa compile.

## Using in a device tree

1. Check it out next to the device, such as in a local manifest:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
    <project name="go7-lineage/android_vendor_onyx_mesa" path="vendor/onyx/mesa" remote="github" revision="master" />
    ...
</manifest>
```

2. In `device.mk`, `$(call inherit-product, vendor/onyx/mesa/mesa.mk)`

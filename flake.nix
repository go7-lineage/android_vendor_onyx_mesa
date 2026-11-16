{
  description = "Mesa freedreno (GLES) and turnip (Vulkan) for Android arm64";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { nixpkgs, ... }: {
    packages = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system: {
      default = nixpkgs.legacyPackages.${system}.callPackage ./nix/mesa.nix { };
    });
  };
}

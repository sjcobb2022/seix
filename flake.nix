{
  description = "SELinux support for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-compat = {
      url = "github:NixOS/flake-compat";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    forEachSystem = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-darwin"
    ];

    forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});
  in {
    overlays.seix = import ./overlay.nix;
    overlays.default = self.overlays.seix;

    nixosModules.seix = import ./module.nix;
    nixosModules.default = self.nixosModules.seix;

    nixosTests.selinux = import ./tests/selinux.nix {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      inherit self;
    };
  };
}

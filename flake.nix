{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs =
    inputs@{ self, flake-parts, }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake.templates = import ./template.nix;
    };
}

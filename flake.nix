{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs@{ self, systems, nixpkgs, flake-parts }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      flake.templates = import ./template.nix;
    };
}

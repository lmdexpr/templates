{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.extend
          (self: super: { ocamlPackages = super.ocaml-ng.ocamlPackages_5_3; });

        otherNativeBuildInputs = [
          pkgs.nodejs_24
        ];

        ocamlNativeBuildInputs = with pkgs.ocamlPackages; [
          dune_3
          ocaml
          findlib
          melange
          reason
        ];

        nativeBuildInputs = otherNativeBuildInputs ++ ocamlNativeBuildInputs;

        buildInputs = with pkgs.ocamlPackages; [
          reason-react
          reason-react-ppx

          ocamlformat
          ocamlformat-lib

          ocaml-lsp
        ];
      in
      {
        legacyPackages = pkgs;

        devShells = {
          default = pkgs.mkShell { inherit nativeBuildInputs buildInputs; };
        };
      });
}

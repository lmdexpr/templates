{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        legacyPackages = pkgs;

        devShells.default =
          pkgs.mkShell {
            buildInputs = with pkgs; [ 
              nil nixpkgs-fmt 
              nodejs_24
            ];
          };
      });
}

{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        artifact = pkgs.buildNpmPackage {
          name = "rescript";

          buildInputs = with pkgs; [
            nodejs_20
          ];

          src = self;

          npmDeps = pkgs.importNpmLock {
            npmRoot = ./.;
          };

          npmConfigHook = pkgs.importNpmLock.npmConfigHook;
        };
      in
      {
        legacyPackages = pkgs;
        packages = {
          default = artifact;
        };

        devShells.default =
          pkgs.mkShell {
            buildInputs = with pkgs; [ 
              nil nixpkgs-fmt 
              nodejs_20
              typescript-language-server
              rescript-language-server
            ];
          };
      });
}

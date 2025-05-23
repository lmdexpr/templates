{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        target = "changeme";
        artifact = pkgs.buildNpmPackage {
          name = target;

          buildInputs = with pkgs; [
            nodejs_24
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
              nodejs_24
              typescript-language-server
              artifact
            ];
            shellHook = ''
              if [ ! -d "./node_modules" ]; then
                npm install
              fi
              if [ -d "./node_modules/.bin" ]; then
                export PATH="$PATH:$(pwd)/node_modules/.bin"
              fi
            '';
          };
      });
}

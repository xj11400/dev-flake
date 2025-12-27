{
  description = "Empty flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-lib = {
      url = "github:xj11400/flake-lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dev-flake = {
      url = "github:xj11400/dev-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      dev-flake,
      flake-lib,
      ...
    }@inputs:
    let
    in
    flake-lib.lib.system.forEachSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          default = pkgs.stdenv.mkDerivation {
            pname = "";
            version = "";

            src = ./.;

            nativeBuildInputs = [ pkgs.gnumake ];

            buildPhase = "make";

            installPhase = "make install";
          };
        };

        devShells = {
          default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
            ];

            buildInputs = [ ];

            inputsFrom = [ ];

            shellHook = '''';
          };
        };
      }
    );
}

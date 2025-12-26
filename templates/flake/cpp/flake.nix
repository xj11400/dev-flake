{
  description = "A simple hello world C++ application with CMake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-lib = {
      url = "github:xj11400/flake-lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
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
            pname = "hello-cpp";
            version = "0.1.0";
            src = ./.;
            nativeBuildInputs = [ pkgs.cmake ];
            # CMake automatically handles buildPhase and installPhase if not overridden
          };
        };

        devShells =
          let
          in
          {
            default = pkgs.mkShell {
              nativeBuildInputs = with pkgs; [
                gcc
                cmake
              ];
            };
          };
      }
    );
}

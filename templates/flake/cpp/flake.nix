{
  description = "A simple hello world C++ application with CMake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, ... }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSystem = inputs.nixpkgs.lib.genAttrs systems;
      legacyPackages = inputs.nixpkgs.legacyPackages;
    in
    {
      packages = forEachSystem (
        system:
        let
          pkgs = legacyPackages.${system};
        in
        {
          default = pkgs.stdenv.mkDerivation {
            pname = "hello-cpp";
            version = "0.1.0";
            src = ./.;
            nativeBuildInputs = [ pkgs.cmake ];
            # CMake automatically handles buildPhase and installPhase if not overridden
          };
        }
      );

      devShells = forEachSystem (
        system:
        let
          pkgs = legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              gcc
              cmake
            ];
          };
        }
      );
    };
}

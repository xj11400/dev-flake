{
  description = "A simple hello world Go application";

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
      packages = forEachSystem (system: {
        default = legacyPackages.${system}.callPackage ./default.nix { };
      });

      devShells = forEachSystem (system: {
        default = legacyPackages.${system}.callPackage ./shell.nix { };
      });
    };
}

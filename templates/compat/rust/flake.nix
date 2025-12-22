{
  description = "x flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, ... }@inputs:
    let
      # supportedSystems = [
      #   "x86_64-linux"
      #   "aarch64-linux"
      #   "x86_64-darwin"
      #   "aarch64-darwin"
      # ];
      # forEachSupportedSystem =
      #   f:
      #   inputs.nixpkgs.lib.genAttrs supportedSystems (
      #     system:
      #     f {
      #       pkgs = import inputs.nixpkgs {
      #         inherit system;
      #         overlays = [
      #           inputs.self.overlays.default
      #         ];
      #       };
      #     }
      #   );

      systems = [
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

{
  description = "Flake for development";

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
      flake-lib,
      nixpkgs,
      ...
    }:
    {
      lib = import ./lib {
        inherit self nixpkgs flake-lib;
      };

      templates = import ./templates { inherit (self) lib; };
    }
    // flake-lib.lib.system.forEachSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        # modules = self.lib.load.shells ./templates/compat { inherit pkgs; };
        # modules = self.lib.load.fromFlake ./templates/flake { inherit pkgs system; };
        modules = self.lib.load.fromFlake ./templates/flake { inherit pkgs; };
      in
      {
        packages = modules.packages;
        devShells = modules.devShells;
      }
    );
}

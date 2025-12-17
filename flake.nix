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
    }@inputs:
    {
      lib = {
        use = flake-lib.lib.dev.use self;
      };

      templates = import ./templates { inherit flake-lib; };
    }
    // flake-lib.lib.system.forEachSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        modules = flake-lib.lib.dev.load.shellsDir ./templates/compat { inherit pkgs; };
        # modules = flake-lib.lib.dev.load.fromFlakeDir ./templates/flake { inherit pkgs inputs; };
      in
      {
        packages = modules.packages;
        devShells = modules.devShells;
      }
    );
}

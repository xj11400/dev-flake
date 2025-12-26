{
  description = "A short description of the flake";

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
    }:
    let
      # systems = [ ... ];
    in
    # specify the systems with prime function
    # flake-lib.lib.system.forEachSystem' { inherit systems;}
    flake-lib.lib.system.forEachSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Get the packages and devShells
        go = dev-flake.use.${system}.go;
        # go.packages;
        # go.devShells;
      in
      {
        packages = {
          # Use packages
          rust = dev-flake.packages.${system}.rust;
        };
        devShells = {
          # Use devShells
          rust = dev-flake.devShells.${system}.rust;
        };
      }
    );
}

{
  description = "A simple hello world Python application";

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
          default = pkgs.python3Packages.buildPythonApplication {
            pname = "hello-python";
            version = "0.1.0";
            src = ./.;
            pyproject = true;
            build-system = [ pkgs.python3Packages.setuptools ];
          };
        };

        devShells =
          let
          in
          {
            default = pkgs.mkShell {
              nativeBuildInputs = with pkgs; [ python3 ];
              inputsFrom = [ self.packages.${system}.default ];
            };
          };
      }
    );
}

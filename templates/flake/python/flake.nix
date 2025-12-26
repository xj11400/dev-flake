{
  description = "A simple hello world Python application";

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
          default = pkgs.python3Packages.buildPythonApplication {
            pname = "hello-python";
            version = "0.1.0";
            src = ./.;
            pyproject = true;
            build-system = [ pkgs.python3Packages.setuptools ];
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
            nativeBuildInputs = with pkgs; [ python3 ];
            inputsFrom = [ self.packages.${system}.default ];
          };
        }
      );
    };
}

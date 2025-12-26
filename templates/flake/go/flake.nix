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
      packages = forEachSystem (
        system:
        let
          pkgs = legacyPackages.${system};
        in
        {
          default = pkgs.buildGoModule {
            pname = "hello-go";
            version = "0.1.0";
            src = ./.;
            vendorHash = null;
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
            nativeBuildInputs = [ pkgs.go pkgs.gopls ];
          };
        }
      );
    };
}

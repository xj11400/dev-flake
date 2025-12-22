{
  description = "A simple hello world Rust application";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-lib = {
      url = "github:xj11400/flake-lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # rust tools
    fenix.url = "github:nix-community/fenix";
    naersk.url = "github:nix-community/naersk";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-lib,
      fenix,
      naersk,
      ...
    }@inputs:
    let
    in
    flake-lib.lib.system.forEachSystem (
      system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
          overlays = [ fenix.overlays.default ];
        };
      in
      {
        packages = {
          default = (pkgs.callPackage naersk { }).buildPackage {
            src = ./.;
          };
        };

        devShells =
          let
            hasCargoLock = builtins.pathExists ./Cargo.lock;
            defaultPackage = self.packages.${system}.default;
          in
          {
            default = pkgs.mkShell {
              # Development tools
              nativeBuildInputs = with pkgs; [
                # toolchain
                (
                  with fenix.packages.${system};
                  combine (
                    with stable;
                    [
                      clippy
                      rustc
                      cargo
                      rustfmt
                      rust-src
                    ]
                  )
                )
                rust-analyzer
              ];

              # Project dependencies
              buildInputs = [ ];

              # Inherit dependencies from project package
              inputsFrom = if hasCargoLock then [ defaultPackage ] else [ ];

              shellHook = ''
                if [ ! -f Cargo.lock ]; then
                  echo "[!] Warning: Cargo.lock not found."
                  echo "  Project dependencies from buildRustPackage are NOT loaded."
                  echo "  Run 'cargo generate-lockfile' or 'cargo build' to create it."
                else
                  echo "Project environment loaded with dependencies from buildRustPackage"
                fi
              '';

              env = {
                RUST_BACKTRACE = 1;
              };
            };
          };
      }
    );
}

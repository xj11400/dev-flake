{
  description = "A simple hello world Rust application";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      supportedSystems = [
        # "x86_64-linux"
        # "aarch64-linux"
        # "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSystem = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.rustPlatform.buildRustPackage {
            pname = "hello-rust";
            version = "0.1.0";

            src = ./.;

            cargoLock = {
              lockFile = ./Cargo.lock;
            };

            meta = with pkgs.lib; {
              description = "A simple hello world Rust application";
              license = licenses.mit;
              platforms = platforms.all;
            };
          };
        }
      );

      devShells = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          hasCargoLock = builtins.pathExists ./Cargo.lock;
          defaultPackage = self.packages.${system}.default;
        in
        {
          default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              cargo
              rustc
              rust-analyzer
              clippy
            ];

            buildInputs = [ ];

            # Automatically inherit dependencies from the package
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

            RUST_BACKTRACE = 1;
          };
        }
      );
    };
}

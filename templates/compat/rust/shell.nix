{
  pkgs ? import <nixpkgs> { },
}:

let
  # Check if Cargo.lock exists
  hasCargoLock = builtins.pathExists ./Cargo.lock;

  # Only import default.nix if both default.nix and Cargo.lock exist
  defaultNix =
    if (builtins.pathExists ./default.nix && hasCargoLock) then
      import ./default.nix { inherit pkgs; }
    else
      null;
in
pkgs.mkShell {
  # Development tools
  nativeBuildInputs = with pkgs; [
    cargo
    clippy
    rust-analyzer
    rustc
    rustfmt
  ];

  # Project dependencies
  buildInputs = [ ];

  # Inherit dependencies from project package
  inputsFrom = if defaultNix != null then [ defaultNix ] else [ ];

  shellHook = ''
    if [ ! -f Cargo.lock ]; then
      echo "[!] Warning: Cargo.lock not found."
      echo "  Project dependencies from default.nix are NOT loaded."
      echo "  Run 'cargo generate-lockfile' or 'cargo build' to create it."
    else
      echo "Project environment loaded."
    fi
  '';

  RUST_BACKTRACE = 1;
  RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
}

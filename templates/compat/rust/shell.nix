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
    rustc
    rust-analyzer
    clippy
  ];

  # Project dependencies
  buildInputs = [ ];

  # Inherit dependencies from project package
  inputsFrom = if defaultNix != null then [ defaultNix ] else [ ];

  shellHook = ''
    if [ -z "${if defaultNix != null then "loaded" else ""}" ]; then
      echo "[!] Warning: Cargo.lock not found or default.nix missing."
      echo "  Project dependencies from default.nix are NOT loaded."
      echo "  Run 'cargo generate-lockfile' or 'cargo build' to create it."
    else
      echo "Project environment loaded from default.nix"
    fi
  '';

  RUST_BACKTRACE = 1;
}

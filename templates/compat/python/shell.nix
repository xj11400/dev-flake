{
  pkgs ? import <nixpkgs> { },
}:

let
  # Check if setup.py or pyproject.toml exists to verify project root
  hasProjectFile = builtins.pathExists ./setup.py || builtins.pathExists ./pyproject.toml;

  # Only import default.nix if we look like a python project
  defaultNix =
    if (builtins.pathExists ./default.nix && hasProjectFile) then
      import ./default.nix { inherit pkgs; }
    else
      null;
in
pkgs.mkShell {
  # Development tools
  nativeBuildInputs = with pkgs; [
    python3
    # python3Packages.black # formatter
    # python3Packages.flake8 # linter
  ];

  # Project dependencies
  buildInputs = [ ];

  # Inherit dependencies from project package
  inputsFrom = if defaultNix != null then [ defaultNix ] else [ ];

  shellHook = ''
    if [ -z "${if defaultNix != null then "loaded" else ""}" ]; then
      echo "[!] Warning: setup.py or pyproject.toml not found or default.nix missing."
      echo "  Project dependencies from default.nix are NOT loaded."
    else
      echo "Project environment loaded from default.nix"
    fi
  '';
}

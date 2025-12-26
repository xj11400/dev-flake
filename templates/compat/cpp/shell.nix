{
  pkgs ? import <nixpkgs> { },
}:

let
  defaultNix =
    if builtins.pathExists ./default.nix then
      import ./default.nix { inherit pkgs; }
    else
      null;
in
pkgs.mkShell {
  # Development tools
  nativeBuildInputs = with pkgs; [
    gcc
    cmake
    # clang-tools
  ];

  # Project dependencies
  buildInputs = [ ];

  # Inherit dependencies/params from project package if needed
  inputsFrom = if defaultNix != null then [ defaultNix ] else [ ];
}

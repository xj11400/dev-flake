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
    gnumake
    # clang-tools
  ];

  # Protect against contamination from user environment
  # shellHook = ''
  #   export CC=gcc
  # '';
  
  inputsFrom = if defaultNix != null then [ defaultNix ] else [ ];
}

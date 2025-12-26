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
    go
    gopls
  ];

  # Project dependencies
  buildInputs = [ ];

  # Inherit dependencies from project package
  inputsFrom = if defaultNix != null then [ defaultNix ] else [ ];
}

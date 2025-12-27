{
  pkgs ? import <nixpkgs> { },
}:

let
  defaultNix =
    if builtins.pathExists ./default.nix then import ./default.nix { inherit pkgs; } else null;
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
  ];

  buildInputs = [ ];

  inputsFrom = if defaultNix != null then [ defaultNix ] else [ ];

  shellHook = '''';

}

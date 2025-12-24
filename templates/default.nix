{
  lib,
}:
let
  msg = ":)\n";

  flake = lib.load.templates ./flake {
    info = ''
      This is a pure flake template.

      - It contains only a `flake.nix` file.
      - Use `nix develop` to enter the development environment.
      - Use `nix build` or `nix run` to build or run the package.

      ${msg}'';
  };

  compat = lib.load.templates ./compat {
    info = ''
      This is a compatible template.

      - It contains `default.nix`, `shell.nix`, and `flake.nix`.
      - It works in both traditional Nix and Flake ways.

      Traditional Nix:

      - Use `nix-shell` to enter the development environment.
      - Use `nix-build` to build the package.

      Flake Nix:

      - Use `nix develop` to enter the development environment.
      - Use `nix build` or `nix run` to build or run the package.

      ${msg}'';
  };
in
{
  flake-compat = {
    path = ./flake-compat;
    description = "flake-compat";
    welcomeText = lib.msg.welcome {
      name = "flake-compat";
      info = "This is the flake-compat template.";
    };
  };

  compat = {
    description = "Collection of compatible templates";
  }
  // compat;
}
// flake

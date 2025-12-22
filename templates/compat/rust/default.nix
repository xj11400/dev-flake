{
  pkgs ? import <nixpkgs> { },
}:
let
in
pkgs.rustPlatform.buildRustPackage {
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
}

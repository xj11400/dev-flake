{
  pkgs ? import <nixpkgs> { },
}:
pkgs.stdenv.mkDerivation {
  pname = "hello-cpp";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ pkgs.cmake ];
}

{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation {
  pname = "";
  version = "";

  src = ./.;

  nativeBuildInputs = [ pkgs.gnumake ];

  buildPhase = "make";

  installPhase = "make install";
}

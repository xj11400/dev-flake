{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation {
  pname = "hello-c";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ pkgs.gnumake ];

  buildPhase = "make";
  
  installPhase = "make install";
}

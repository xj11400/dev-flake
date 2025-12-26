{
  pkgs ? import <nixpkgs> { },
}:
pkgs.buildGoModule {
  pname = "hello-go";
  version = "0.1.0";

  src = ./.;

  # vendorHash = lib.fakeSha256; # Use this if you have dependencies
  vendorHash = null; # Use null if no dependencies
}

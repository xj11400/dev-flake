{
  pkgs ? import <nixpkgs> { },
}:

pkgs.python3Packages.buildPythonApplication {
  pname = "hello-python";
  version = "0.1.0";

  src = ./.;

  pyproject = true;
  build-system = [ pkgs.python3Packages.setuptools ];

  # Helper to make sure we have a valid python project
  # In a real project you should have setup.py or pyproject.toml
  # This makes it work with just main.py for a super simple example if needed, 
  # but we will provide setup.py in the template.
}

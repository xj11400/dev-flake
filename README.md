# dev-flake

A Nix flake providing development environments and project templates.

## Usage

### As a Flake Input

Add your `dev-flake` to `flake.nix` inputs:

[Usage flake.nix](./templates/usage/flake.nix)

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    dev-flake.url = "github:xj11400/dev-flake";
    dev-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, dev-flake, ... }:
    let
      # Get the packages and devShells
      # go = dev-flake.use.${system}.go;
      # => {
      #      packages = << Derivation >>;
      #      devShell = << Derivation >>;
      #    };
    in
    {
    # Use packages or devShells
    # dev-flake.packages.${system}.rust
    # dev-flake.devShells.${system}.rust
    };
}
```

### Using Templates

Initialize a new project using the provided templates.

#### Template Types

- **Pure Flake**: Minimalist templates containing only a `flake.nix`.
  - Use `nix develop` to enter the environment.
  - Use `nix build` or `nix run` for build/execution.
- **Compatible**: Robust templates featuring `default.nix`, `shell.nix`, and `flake.nix`.
  - Supports both traditional Nix (`nix-shell`, `nix-build`) and modern Flakes.

#### Initialize a Project

```bash
# List available templates
nix flake show github:xj11400/dev-flake

# Initialize using a specific template
# Example: nix flake init -t github:xj11400/dev-flake#rust
nix flake init -t github:xj11400/dev-flake#<template-name>

# For compatible templates (prefix with 'compat.')
# Example: nix flake init -t github:xj11400/dev-flake#compat.rust
nix flake init -t github:xj11400/dev-flake#compat.<template-name>
```

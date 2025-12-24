# dev-flake

A Nix flake providing development environments and project templates.

## Features

- **Development Shells**: Pre-configured environments for languages and tools.
- **Packages**: Bundled environments using `buildEnv`.
- **Templates**: Templates for creating new projects.

## Usage

### Using Library Functions to Manage a Development Flake

Refer to the [Library Usage Guide](./doc/lib.md).

See the [Flake](./flake.nix) and [Default Template](./templates/default.nix).

```nix
templates = lib.load.templates ./flake {
  info = ''
    This is a pure flake template.
  '';
};
```

### As a Flake Input

Add `dev-flake` to `flake.nix` inputs:

[Usage flake.nix](./templates/usage/flake.nix)

```nix
{
  inputs = {
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

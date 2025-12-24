{
  self,
  nixpkgs,
  flake-lib,
  ...
}:
rec {
  msg = import ./msg.nix { inherit nixpkgs; };
  load = import ./load.nix { inherit flake-lib nixpkgs msg; };

  /**
    Retrieves packages and devShells for a specific system and target.

    # Type
    ```
    use :: String -> String -> { packages :: Derivation, devShells :: Derivation }
    ```

    # Example
    ```nix
    lib.use "x86_64-linux" "rust"
    # => {
    #      packages = << Derivation >>;
    #      devShell = << Derivation >>;
    #    };
    ```
  */
  use = system: target: {
    packages = self.packages.${system}.${target};
    devShells = self.devShells.${system}.${target};
  };
}

{
  flake-lib,
  nixpkgs,
  msg,
}:
{
  /**
    Loads templates from subdirectories of a given path.

    # Type
    ```
    templates :: Path -> { info :: String } -> Attrs
    ```

    # Example
    ```nix
    lib.load.templates ./templates { info = "v1.0"; }
    ```
  */
  templates =
    path: args:
    let
      info = args.info or ":)";
      dirs = flake-lib.lib.file.getDirs' path;
      genTemplate =
        name:
        let
          dirPath = path + "/${name}";
          flakeFile = dirPath + "/flake.nix";
          flake = if builtins.pathExists flakeFile then import flakeFile else { };
          description = flake.description or "Template for ${name}";
        in
        {
          inherit name;
          value = {
            path = dirPath;
            inherit description;
            welcomeText = msg.welcome {
              inherit name;
              inherit info;
            };
          };
        };
    in
    builtins.listToAttrs (map genTemplate dirs);

  /**
    Loads development shells and creates corresponding packages from subdirectories.
    It expects each subdirectory to contain a `shell.nix` file.

    # Type
    ```
    shells :: Path -> { pkgs :: Attrs, ... } -> { packages :: Attrs, devShells :: Attrs }
    ```

    # Example
    ```nix
    lib.load.shells ./shells { inherit pkgs; }
    ```
  */
  shells =
    path: args:
    let
      inherit (args) pkgs;
      dirs = flake-lib.lib.file.getDirs' path;

      genShell =
        name:
        let
          dirPath = path + "/${name}";
          shellFile = dirPath + "/shell.nix";
          shell = import shellFile args;
          nativeBuildInputs = shell.nativeBuildInputs or [ ];

          package = pkgs.buildEnv {
            inherit name;
            paths = nativeBuildInputs;
          };

          devShell = shell.overrideAttrs (oldAttrs: {
            shellHook = ''
              ${msg.pkgs_loadded nativeBuildInputs { }}
            '';
          });
        in
        [
          {
            name = name;
            value = package;
          }
          {
            name = name;
            value = devShell;
          }
        ];

      results = map genShell dirs;
      packages = builtins.listToAttrs (map (res: builtins.elemAt res 0) results);
      devShells = builtins.listToAttrs (map (res: builtins.elemAt res 1) results);
    in
    {
      inherit packages devShells;
    };

  /**
    Loads development shells from `flake.nix` files in subdirectories.
    Each subdirectory is expected to be a flake.
    If the devShell has multiple shells, the default shell is named after the directory,
    and other shells are named as `$directory-$shellName`.

    # Type
    ```
    fromFlake :: Path -> { pkgs :: Attrs, ... } -> { packages :: Attrs, devShells :: Attrs }
    ```

    # Example
    ```nix
    lib.load.fromFlake ./templates/flake { inherit pkgs; }
    ```
  */
  fromFlake =
    path: args:
    let
      inherit (args) pkgs;
      system = args.system or pkgs.stdenv.hostPlatform.system;
      dirs = flake-lib.lib.file.getDirs' path;

      genShellsFromFlake =
        dirName:
        let
          dirPath = path + "/${dirName}";
          flakeFile = dirPath + "/flake.nix";
          flake = if builtins.pathExists flakeFile then import flakeFile else { };

          # Basic evaluation of outputs if it's a function
          outputs =
            if builtins.isFunction (flake.outputs or null) then
              flake.outputs (
                (flake.inputs or { })
                // {
                  self = flake;
                  inherit nixpkgs;
                }
              )
            else
              flake.outputs or { };

          flakeDevShells = outputs.devShells.${system} or { };

          genShell =
            shellName: shell:
            let
              finalName = if shellName == "default" then dirName else "${dirName}-${shellName}";
              nativeBuildInputs = shell.nativeBuildInputs or [ ];

              package = pkgs.buildEnv {
                name = finalName;
                paths = nativeBuildInputs;
              };

              devShell = shell.overrideAttrs (oldAttrs: {
                shellHook = ''
                  ${msg.pkgs_loadded nativeBuildInputs { }}
                '';
              });
            in
            {
              inherit finalName package devShell;
            };

          shells = nixpkgs.lib.mapAttrsToList genShell flakeDevShells;
        in
        shells;

      allResults = nixpkgs.lib.flatten (map genShellsFromFlake dirs);

      packages = builtins.listToAttrs (
        map (res: {
          name = res.finalName;
          value = res.package;
        }) allResults
      );
      devShells = builtins.listToAttrs (
        map (res: {
          name = res.finalName;
          value = res.devShell;
        }) allResults
      );
    in
    {
      inherit packages devShells;
    };
}

# Message functions {#sec-functions-library-msg}


## `lib.msg.pkgs_loadded` {#dev-flake.lib.msg.pkgs_loadded}

Generates a shell script snippet to echo a title and list of loaded packages.

### Type
```
pkgs_loadded :: [Derivation] -> { title :: String } -> String
```

### Example
```nix
lib.msg.pkgs_loadded [ pkgs.hello ] { title = "My packages:"; }
```

## `lib.msg.pkgs_list` {#dev-flake.lib.msg.pkgs_list}

Generates a shell script snippet to echo each package in the list.

### Type
```
pkgs_list :: [Derivation] -> String
```

### Example
```nix
lib.msg.pkgs_list [ pkgs.hello ]
```

## `lib.msg.welcome` {#dev-flake.lib.msg.welcome}

Generates a welcome message for a template.

### Type
```
welcome :: { name :: String, info :: String } -> String
```

### Example
```nix
lib.msg.welcome { name = "rust"; info = "Happy coding!"; }
```


# Load functions {#sec-functions-library-load}


## `lib.load.templates` {#dev-flake.lib.load.templates}

Loads templates from subdirectories of a given path.

### Type
```
templates :: Path -> { info :: String } -> Attrs
```

### Example
```nix
lib.load.templates ./templates { info = "v1.0"; }
```

## `lib.load.shells` {#dev-flake.lib.load.shells}

Loads development shells and creates corresponding packages from subdirectories.
It expects each subdirectory to contain a `shell.nix` file.

### Type
```
shells :: Path -> { pkgs :: Attrs, ... } -> { packages :: Attrs, devShells :: Attrs }
```

### Example
```nix
lib.load.shells ./shells { inherit pkgs; }
```

## `lib.load.fromFlake` {#dev-flake.lib.load.fromFlake}

Loads development shells from `flake.nix` files in subdirectories.
Each subdirectory is expected to be a flake.
If the devShell has multiple shells, the default shell is named after the directory,
and other shells are named as `$directory-$shellName`.

### Type
```
fromFlake :: Path -> { pkgs :: Attrs, ... } -> { packages :: Attrs, devShells :: Attrs }
```

### Example
```nix
lib.load.fromFlake ./templates/flake { inherit pkgs; }
```


# Core functions {#sec-functions-library-lib}


## `lib.use` {#dev-flake.lib.use}

Retrieves packages and devShells for a specific system and target.

### Type
```
use :: String -> String -> { packages :: Derivation, devShells :: Derivation }
```

### Example
```nix
lib.use "x86_64-linux" "rust"
# => {
#      packages = << Derivation >>;
#      devShell = << Derivation >>;
#    };
```



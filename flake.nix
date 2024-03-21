{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    utils.url = "github:numtide/flake-utils";

    my-nvim = {
      url = "github:JoakimPaulsson/nix-neovim-build";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, utils, my-nvim }: 
  utils.lib.eachDefaultSystem (system:
    let
      # projRoot = builtins.toString(./.);
      overlays = [
        (final: prev: { neovim = final.callPackage my-nvim { }; })
      ];
      pkgs = import nixpkgs {
        inherit system overlays;
      };
      lnNvimConfig = 
        ''
          ln -s "$(pwd)"/nvim "$XDG_CONFIG_HOME"/
        '';
      mkXDGEnv = variant:
      let
        uVariant = pkgs.lib.toUpper variant;
      in 
        ''
          export XDG_${uVariant}_HOME=$(mktemp -d --tmpdir="$(pwd)"/.tmp .${variant}.XXX)
        '';
      xdgEnv = pkgs.lib.concatStrings (
        (builtins.map 
          mkXDGEnv 
          ["config" "cache" "data" "state"] 
        ) ++ [ lnNvimConfig ]
      );
    in
    {
      devShells.default = with builtins; pkgs.mkShell {
        packages = with pkgs; [
          neovim
        ];
        shellHook = 
        ''
          # More stuff
        '' + xdgEnv;
      };
    });
}

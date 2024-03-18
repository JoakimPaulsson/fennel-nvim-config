{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    utils.url = "github:numtide/flake-utils";

    my-nvim = {
      url = "github:JoakimPaulsson/nix-neovim-build";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, utils, my-nvim }: utils.lib.eachDefaultSystem (system:
    let
      overlays = [
        (final: prev: { neovim = final.callPackage my-nvim { }; })
      ];
      pkgs = import nixpkgs {
        inherit system overlays;
      };
    in
    {
      devShells.default = pkgs.mkShell {

        packages = with pkgs; [
          neovim
        ];

        env = {
          XDG_CONFIG_HOME = "${self}/nvim-config";
        };

      };
    }
  );
}

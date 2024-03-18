{
  inputs = {
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
      pkgs = nixpkgs.legacyPackages.${system} { inherit overlays; };
    in
    {
      devShell = pkgs.mkShell {
        packages = with pkgs; [
          neovim
        ];
        # buildInputs = with pkgs; [
        # ];
      };
    }
  );
}

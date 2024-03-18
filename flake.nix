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
      tmp-dir = /tmp/fennel-nvim-config-tmp;
    in
    {
      devShells.default = pkgs.mkShell {

        packages = with pkgs; [
          neovim
        ];

        # env = {
        #   XDG_CONFIG_HOME = "${self}/nvim-config";
        #   XDG_CACHE_HOME = "${tmp-dir}/cache";
        #   XDG_DATA_HOME = "${tmp-dir}/local/share";
        #   XDG_STATE_HOME = "${tmp-dir}/local/state";
        # };

        # shellHook = 
        #   ''
        #     if [[ ! -d ${tmp-dir} ]]; then
        #             mkdir -p ${tmp-dir}/cache
        #             mkdir -p ${tmp-dir}/local/state
        #             mkdir -p ${tmp-dir}/local/share
        #     fi
        #   '';

      };
    }
  );
}

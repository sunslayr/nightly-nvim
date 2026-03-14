{
    description = "Portable, Isolated, Neovim flake using Lassulus/wrappers and flake-parts";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        wrappers.url = "github:Lassulus/wrappers";
        flake-parts.url = "github:hercules-ci/flake-parts";


        tree-sitter-pkg.url = "github:tree-sitter/tree-sitter";

	neovim-nightly-overlay = {
            url = "github:nix-community/neovim-nightly-overlay/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };

    };

    outputs = inputs @ { flake-parts, ... }:

        flake-parts.lib.mkFlake { inherit inputs; }
            {
                imports = [
                    ./neovim/neovim.nix
                ];

                _module.args = {
                    appDataDir = "/home/user/.portableNeovim";
                };
            };
}

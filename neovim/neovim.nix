{
    inputs,
    appDataDir,
    ...
}:
{
    systems = [ "x86_64-linux" ];
    perSystem = { pkgs, self', inputs', system, ... }:
    let
        runtimeList = [
            inputs'.tree-sitter-pkg.packages.default
            pkgs.git
            pkgs.curl
            pkgs.unzip
            pkgs.ripgrep
            pkgs.rustc
            pkgs.cargo
            pkgs.nodejs_24
            pkgs.gcc
            pkgs.bash
            pkgs.gzip

            pkgs.lua-language-server
            pkgs.nixd
        ];
    in
    {
        _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
                inputs.neovim-nightly-overlay.overlays.default
            ];
        };

        packages.mypackage = inputs.wrappers.lib.wrapPackage {
            inherit pkgs;
            package = pkgs.neovim;
            runtimeInputs = runtimeList;
            preHook = ''
                # Create the directory if it doesn't exist
                mkdir -p "${appDataDir}/.config/nvim"

                # Copy init.lua from nix store, do not override
                cp -n "${./init.lua}" "${appDataDir}/.config/nvim/init.lua"
                chmod 755 "${appDataDir}/.config/nvim/init.lua"
            '';
            env = {
                "XDG_DATA_HOME" = "${appDataDir}/.local/share";
                "XDG_CONFIG_HOME" = "${appDataDir}/.config";
                "HOME" = "${appDataDir}";
            };
        };

        packages.default = self'.packages.mypackage;
        devShells.default = pkgs.mkShell {
            packages = [ self'.packages.mypackage ] ++runtimeList;
        };
    };
}

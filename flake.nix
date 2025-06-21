{
  inputs = {
    nvf.url = "github:notashelf/nvf";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      flake-utils,
      nvf,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        configPath = "programs.nvf-config";
      in
      {
        # Add a NixOS module that can be imported directly
        nixosModules.default =
          {
            pkgs,
            lib,
            config,
            ...
          }:
          {
            options.${configPath} = {
              enable = lib.mkEnableOption "Custom Neovim configuration via nvf";
            };

            config = lib.mkIf config.${configPath}.enable {
              environment.systemPackages = [
                (nvf.lib.neovimConfiguration {
                  inherit pkgs;
                  modules = [
                    (import ./nvf.nix { })
                  ];
                }).neovim
              ];
            };
          };
      }
    );
}

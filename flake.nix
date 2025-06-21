{
  inputs = {
    nvf.url = "github:notashelf/nvf";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      flake-utils,
      nvf,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (system: {
      # Add a NixOS module that can be imported directly
      nixosModules = {
        default = self.nixosModules.nvf-config;
        nvf-config =
          {
            pkgs,
            lib,
            config,
            ...
          }:
          {
            options.programs.nvf-custom = {
              enable = lib.mkEnableOption "Custom Neovim configuration via nvf";
            };

            config = lib.mkIf config.programs.nvf-custom.enable {
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
      };
    });
}

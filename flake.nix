{
  description = "Kenneth Hoff's nvf configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      flake-utils,
      nvf,
      nixpkgs,
      ...
    }:
    let
      mkConfig =
        {
          pkgs,
          screenshotDirectory,
        }:
        (nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [
            (import ./nvf.nix {
              inherit pkgs;
              screenshotDirectory = screenshotDirectory;
            })
          ];
        }).neovim;
      # Define the module outside eachDefaultSystem so it's available at the top level
      nvf-config-module =
        {
          pkgs,
          lib,
          config,
          ...
        }:
        {
          options.programs.nvf-config = {
            enable = lib.mkEnableOption "Custom Neovim configuration via nvf";
            screenshotDirectory = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              description = "Where to output screenshots";
              default = null;
            };
          };

          config = lib.mkIf config.programs.nvf-config.enable {
            environment.systemPackages = [
              (mkConfig {
                inherit pkgs;
                inherit (config.programs.nvf-config) screenshotDirectory;
              })
            ];
          };
        };

      # Home Manager module
      hm-nvf-config-module =
        {
          pkgs,
          lib,
          config,
          ...
        }:
        {
          options.programs.nvf-config = {
            enable = lib.mkEnableOption "Custom Neovim configuration via nvf";
            screenshotDirectory = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              description = "Where to output screenshots";
              default = null;
            };
          };

          config = lib.mkIf config.programs.nvf-config.enable {
            home.packages = [
              (mkConfig {
                inherit pkgs;
                inherit (config.programs.nvf-config) screenshotDirectory;
              })
            ];
          };
        };
    in
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        formatter = pkgs.nixfmt;

        packages.default = mkConfig {
          inherit pkgs;
          screenshotDirectory = null;
        };
      }
    ))
    // {
      # Expose both modules at the top level
      nixosModules.nvf-config = nvf-config-module;
      homeModules.nvf-config = hm-nvf-config-module;
    };
}

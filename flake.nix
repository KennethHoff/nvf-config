{
  description = "Kenneth Hoff's nvf configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager"; # Added home-manager input
  };

  outputs = {
    flake-utils,
    nvf,
    nixpkgs,
    home-manager,
    ...
  }: let
    mkConfig = pkgs:
      (nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [
          (import ./nvf.nix {
            inherit pkgs;
          })
        ];
      }).neovim;
    # Define the module outside eachDefaultSystem so it's available at the top level
    nvf-config-module = {
      pkgs,
      lib,
      config,
      ...
    }: {
      options.programs.nvf-config = {
        enable = lib.mkEnableOption "Custom Neovim configuration via nvf";
      };

      config = lib.mkIf config.programs.nvf-config.enable {
        environment.systemPackages = [
          (mkConfig pkgs)
        ];
      };
    };

    # Home Manager module
    hm-nvf-config-module = {
      pkgs,
      lib,
      config,
      ...
    }: {
      options.programs.nvf-config = {
        enable = lib.mkEnableOption "Custom Neovim configuration via nvf";
      };

      config = lib.mkIf config.programs.nvf-config.enable {
        home.packages = [
          (mkConfig pkgs)
        ];
      };
    };
  in
    (flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = mkConfig pkgs;
      }
    ))
    // {
      # Expose both modules at the top level
      nixosModules.nvf-config = nvf-config-module;
      homeModules.nvf-config = hm-nvf-config-module;
    };
}

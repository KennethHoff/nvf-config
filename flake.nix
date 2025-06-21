{
  description = "Kenneth Hoff's nvf configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      flake-utils,
      nvf,
      nixpkgs,
      ...
    }:
    let
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
          };

          config = lib.mkIf config.programs.nvf-config.enable {
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
    in
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default =
          (nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [
              (import ./nvf.nix { })
            ];
          }).neovim;
      }
    ))
    // {
      # Expose the module at the top level with the name your main flake is looking for
      nixosModules.nvf-config = nvf-config-module;
    };
}

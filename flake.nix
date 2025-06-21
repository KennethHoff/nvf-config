{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      packages.x86_64-linux = {
        default =
          let
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
          in
          (inputs.nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [
              (import ./nvf.nix { })
            ];
          }).neovim;
      };
    };
}

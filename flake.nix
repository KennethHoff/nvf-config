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
          (inputs.nvf.lib.neovimConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              {
                config.vim = {
                  theme = {
                    enable = true;
                    name = "catppuccin";
                    style = "mocha";
                  };

                  fzf-lua = {
                    enable = true;
                  };
                  utility = {
                    yazi-nvim = {
                      enable = true;
                      mappings = {
                        openYazi = "<leader>e";
                      };
                      setupOpts = {
                        open_for_directories = true;
                      };
                    };
                  };

                  mini = {
                    surround.enable = true;
                    splitjoin.enable = true;
                    indentscope.enable = true;
                  };

                  languages = {
                    nix = {
                      enable = true;
                      lsp.server = "nixd";
                      treesitter.enable = true;
                    };
                  };
                };
              }
            ];
          }).neovim;
      };
    };
}

{ }:
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

    autocomplete = {
      blink-cmp = {
        enable = true;
      };
    };

    binds = {
      whichKey = {
        enable = true;
      };
    };

    lsp = {
      enable = true;
      trouble = {
        enable = true;
      };
    };

    languages = {
      nix = {
        enable = true;
        lsp.server = "nixd";
        treesitter.enable = true;
      };
      csharp = {
        enable = true;
        treesitter.enable = true;
        lsp.enable = true;
      };
    };
  };
}

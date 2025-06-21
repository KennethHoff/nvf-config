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

    visuals = {
      fidget-nvim = {
        enable = true;
      };
    };

    debugger.nvim-dap = {
      enable = true;
      ui = {
        enable = true;
      };
    };

    lsp = {
      enable = true;
      formatOnSave = true;
      inlayHints.enable = true;
      trouble = {
        enable = true;
      };
    };

    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;
      enableDAP = true;

      tailwind = {
        enable = true;
        lsp.enable = true;
      };
      ts.enable = true;
      nix.enable = true;
      csharp = {
        enable = true;
        lsp.enable = true;
      };
    };
  };
}

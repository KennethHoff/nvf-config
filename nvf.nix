{
  pkgs,
  screenshotDirectory ? null,
  ...
}: let
  miniPickKeymap = [
    {
      key = "<leader>ff";
      mode = "n";
      action = "<cmd>Pick files<CR>";
      desc = "Pick - Files";
    }
    {
      key = "<leader>fr";
      mode = "n";
      action = "<cmd>Pick resume<CR>";
      desc = "Pick - Resume";
    }
    {
      key = "<leader>fh";
      mode = "n";
      action = "<cmd>Pick history<CR>";
      desc = "Pick - History";
    }
  ];
  codesnapKeymap = [
    {
      key = "<leader>cc";
      mode = "v";
      action = "<Esc><cmd>CodeSnap<cr>";
      desc = "Copy a code snapshot to clipboard";
    }
    {
      key = "<leader>cs";
      mode = "v";
      action = "<Esc><cmd>CodeSnapSave<cr>";
      desc = "Save a code snapshot as an image";
    }
  ];
in {
  config.vim = {
    enableLuaLoader = true;
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
      smart-splits.enable = true;
    };

    mini = {
      surround.enable = true;
      splitjoin.enable = true;
      indentscope.enable = true;
      pick.enable = true;
      extra.enable = true;
      icons.enable = true;
    };

    autocomplete = {
      blink-cmp = {
        enable = true;
        setupOpts.keymap.preset = "default";
      };
    };

    assistant = {
      codecompanion-nvim = {
        enable = true;
        setupOpts.strategies = {
          chat.adapter = "copilot";
          inline.adapter = "copilot";
        };
      };
      # Used as source for auth for `CodeCompanion`.
      copilot.enable = true;
    };

    git = {
      git-conflict.enable = true;
      gitsigns.enable = true;
      gitlinker-nvim.enable = true;
    };

    # keymaps = fzfLuaKeymap ++ codesnapKeymap;
    keymaps = miniPickKeymap ++ codesnapKeymap;

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
      trouble.enable = true;
      otter-nvim.enable = true;
    };

    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;
      enableDAP = true;

      tailwind.enable = true;
      ts = {
        enable = true;
        extensions = {
          ts-error-translator.enable = true;
        };
      };
      nix.enable = true;
      ruby.enable = true;
      csharp = {
        enable = true;
        lsp.package = pkgs.csharp-ls.overrideAttrs (old: {
          meta =
            old.meta
            // {
              badPlatforms = [];
            };
        });
      };
      yaml.enable = true;
    };

    extraPlugins = {
      "codesnap.nvim" = {
        package = pkgs.vimPlugins.codesnap-nvim;
        setup = ''
          require("codesnap").setup({
            ${
            if screenshotDirectory != null
            then ''save_path="${screenshotDirectory}",''
            else ""
          }
            has_breadcrumbs = true;
            bg_theme = "bamboo";
            show_workspace = true;
            has_line_number = true;
            bg_padding = 0;
          })
        '';
      };
    };
  };
}

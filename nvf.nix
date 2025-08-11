{
  pkgs,
  screenshotDirectory ? null,
  ...
}: let
  fzfLuaKeymap = [
    {
      key = "<leader>ff"; # Fzf Files
      mode = "n";
      action = "<cmd>FzfLua files<CR>";
      desc = "Pick - File";
    }
    {
      key = "<leader>fg"; # Fzf Grep
      mode = "n";
      action = "<cmd>FzfLua grep<CR>";
      desc = "Pick - Live Grep";
    }
    {
      key = "<leader>f*"; # Fzf Grep w/ current word
      mode = "n";
      action = "<cmd>FzfLua grep_cword<CR>";
      desc = "Pick - Grep word under cursor";
    }
    {
      key = "<leader>f*"; # Fzf Grep w/ current selection
      mode = "v";
      action = "<cmd>FzfLua grep_visual<CR>";
      desc = "Pick - Grep current selection";
    }
    {
      key = "<leader>fr"; # Fzf resume previous search
      mode = "n";
      action = "<cmd>FzfLua resume<CR>";
      desc = "Pick - Resume";
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
      key = "<leader>cC";
      mode = "v";
      action = "<Esc><cmd>CodeSnapHighlight<cr>";
      desc = "Copy a highlighted code snapshot to clipboard";
    }
    {
      key = "<leader>cs";
      mode = "v";
      action = "<Esc><cmd>CodeSnapSave<cr>";
      desc = "Save a code snapshot as an image";
    }
    {
      key = "<leader>cS";
      mode = "v";
      action = "<Esc><cmd>CodeSnapSaveHighlight<cr>";
      desc = "Save a highlighted code snapshot as an image";
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
      move.enable = true;
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

    keymaps = fzfLuaKeymap ++ codesnapKeymap;

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

    lazy.plugins = {
      "codesnap.nvim" = {
        package = pkgs.vimPlugins.codesnap-nvim;
        setupOpts = {
          save_path = pkgs.lib.mkIf screenshotDirectory screenshotDirectory;
          has_breadcrumbs = true;
          bg_theme = "bamboo";
          show_workspace = true;
          has_line_number = true;
          bg_padding = 0;
        };
      };
    };
  };
}

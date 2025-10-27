{
  pkgs,
  screenshotDirectory ? null,
  ...
}: let
  snacksPickerKeymap = [
    {
      key = "<leader>ff"; # Files
      mode = "n";
      action = "<cmd>lua Snacks.picker('files')<CR>";
      desc = "Pick - File";
    }
    {
      key = "<leader>fg"; # Live Grep
      mode = "n";
      action = "<cmd>lua Snacks.picker('live_grep')<CR>";
      desc = "Pick - Live Grep";
    }
    {
      key = "<leader>f*"; # Grep word under cursor
      mode = "n";
      action = "<cmd>lua Snacks.picker('grep_word')<CR>";
      desc = "Pick - Grep word under cursor";
    }
    {
      key = "<leader>f*"; # Grep current selection (visual)
      mode = "v";
      action = "<cmd>lua Snacks.picker('grep_word')<CR>";
      desc = "Pick - Grep current selection";
    }
    {
      key = "<leader>fr"; # Resume previous search
      mode = "n";
      action = "<cmd>lua Snacks.picker('resume')<CR>";
      desc = "Pick - Resume previous search";
    }
    {
      key = "<leader>fb"; # Buffers
      mode = "n";
      action = "<cmd>lua Snacks.picker('buffers')<CR>";
      desc = "Pick - Buffer";
    }
    {
      key = "<leader>fo"; # Recent files (oldfiles)
      mode = "n";
      action = "<cmd>lua Snacks.picker('oldfiles')<CR>";
      desc = "Pick - Recent Files";
    }
    {
      key = "<leader>fh"; # Help tags
      mode = "n";
      action = "<cmd>lua Snacks.picker('help_tags')<CR>";
      desc = "Pick - Help Tags";
    }
    {
      key = "<leader>fc"; # Commands
      mode = "n";
      action = "<cmd>lua Snacks.picker('commands')<CR>";
      desc = "Pick - Commands";
    }
    {
      key = "<leader>fk"; # Keymaps
      mode = "n";
      action = "<cmd>lua Snacks.picker('keymaps')<CR>";
      desc = "Pick - Keymaps";
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
      snacks-nvim.enable = true;
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

    keymaps = snacksPickerKeymap ++ codesnapKeymap;

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

      svelte.enable = true;
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

{
  pkgs,
  screenshotDirectory ? null,
  ...
}: let
  snacksPickerKeymap = [
    {
      key = "<leader>ff"; # Files
      mode = "n";
      action = "<cmd>lua Snacks.picker.git_files()<CR>";
      desc = "Pick - File";
    }
    {
      key = "<leader>fg"; # Live Grep
      mode = "n";
      action = "<cmd>lua Snacks.picker.git_grep()<CR>";
      desc = "Pick - Live Grep";
    }
    {
      key = "<leader>f*"; # Grep word under cursor
      mode = "n";
      action = "<cmd>lua Snacks.picker.grep_word()<CR>";
      desc = "Pick - Grep word under cursor";
    }
    {
      key = "<leader>f*"; # Grep current selection (visual)
      mode = "v";
      action = "<cmd>lua Snacks.picker.grep_word()<CR>";
      desc = "Pick - Grep current selection";
    }
    {
      key = "<leader>fr"; # Resume previous search
      mode = "n";
      action = "<cmd>lua Snacks.picker.resume()<CR>";
      desc = "Pick - Resume previous search";
    }
    {
      key = "<leader>fb"; # Buffers
      mode = "n";
      action = "<cmd>lua Snacks.picker.buffers()<CR>";
      desc = "Pick - Buffer";
    }
    {
      key = "<leader>fo"; # Recent files (oldfiles)
      mode = "n";
      action = "<cmd>lua Snacks.picker.oldfiles()<CR>";
      desc = "Pick - Recent Files";
    }
    {
      key = "<leader>fh"; # Help tags
      mode = "n";
      action = "<cmd>lua Snacks.picker.help_tags()<CR>";
      desc = "Pick - Help Tags";
    }
    {
      key = "<leader>fc"; # Commands
      mode = "n";
      action = "<cmd>lua Snacks.picker.commands()<CR>";
      desc = "Pick - Commands";
    }
    {
      key = "<leader>fk"; # Keymaps
      mode = "n";
      action = "<cmd>lua Snacks.picker.keymaps()<CR>";
      desc = "Pick - Keymaps";
    }
    {
      key = "<leader>fp"; # Pickers
      mode = "n";
      action = "<cmd>lua Snacks.picker.pickers()<CR>";
      desc = "Pick - Keymaps";
    }
  ];
in {
  config.vim = {
    enableLuaLoader = true;

    globals = {
      autoread = true;

      opencode_opts = {
        provider = {
          cmd = "opencode --port";
          enabled = "tmux";
        };
      };
    };

    autocmds = [
      {
        # Keep buffers synchronized with on-disk changes.
        # `:checktime` detects when the file changed outside Neovim and triggers the normal reload/prompt behavior.
        # This matters when switching git branches, running formatters, or when tools like `opencode` edit files.
        event = ["FocusGained" "BufEnter" "CursorHold" "CursorHoldI"];
        pattern = ["*"];
        command = "checktime";
      }
    ];
    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
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
      snacks-nvim = {
        enable = true;
        setupOpts = {
          input = {};
          picker = {};
        };
      };
    };

    mini = {
      surround.enable = true;
      splitjoin.enable = true;
      indentscope.enable = true;
      move.enable = true;
    };

    autocomplete.blink-cmp = {
      enable = true;
      setupOpts.keymap.preset = "default";
    };

    git = {
      git-conflict.enable = true;
      gitsigns.enable = true;
      gitlinker-nvim.enable = true;
    };

    keymaps = snacksPickerKeymap;

    binds.whichKey.enable = true;

    visuals.fidget-nvim.enable = true;

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
      nix = {
        lsp.servers = ["nixd"];
        enable = true;
      };
      tailwind.enable = true;
      ts.enable = true;
      csharp = {
        enable = true;
        lsp.servers = ["roslyn_ls"];
      };
      svelte.enable = true;
      yaml.enable = true;
    };

    lazy.plugins = {
      "opencode.nvim" = {
        package = pkgs.vimPlugins.opencode-nvim;

        keys = [
          {
            key = "<leader>oa";
            mode = ["n" "x"];
            action = "<cmd>lua require('opencode').ask('@this: ', { submit = true })<CR>";
            desc = "Ask opencode…";
          }
          {
            key = "<leader>ox";
            mode = ["n" "x"];
            action = "<cmd>lua require('opencode').select()<CR>";
            desc = "Execute opencode action…";
          }
          {
            key = "<leader>ot";
            mode = ["n" "t"];
            action = "<cmd>lua require('opencode').toggle()<CR>";
            desc = "Toggle opencode";
          }

          {
            key = "<leader>or";
            mode = ["n" "x"];
            action = "<cmd>lua return require('opencode').operator('@this ')<CR>";
            desc = "Add range to opencode";
          }
          {
            key = "<leader>ol";
            mode = "n";
            action = "<cmd>lua return require('opencode').operator('@this ') .. '_' <CR>";
            desc = "Add line to opencode";
          }

          {
            key = "<leader>ou";
            mode = "n";
            action = "<cmd>lua require('opencode').command('session.half.page.up')<CR>";
            desc = "Scroll opencode up";
          }
          {
            key = "<leader>od";
            mode = "n";
            action = "<cmd>lua require('opencode').command('session.half.page.down')<CR>";
            desc = "Scroll opencode down";
          }
        ];
      };
      "codesnap.nvim" = {
        package = pkgs.vimPlugins.codesnap-nvim;
        setupModule = "codesnap";
        keys = [
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
        setupOpts = {
          show_line_number = false;

          snapshot_config = {
            window.margin = {
              x = 0;
              y = 0;
            };

            code_config = {
              breadcrumbs.enable = true;
            };
          };
        };
      };
    };
  };
}

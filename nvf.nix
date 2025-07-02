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
    };

    autocomplete = {
      blink-cmp = {
        enable = true;
        setupOpts.keymap.preset = "default";
      };
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
      trouble = {
        enable = true;
      };
    };

    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;
      enableDAP = true;

      tailwind.enable = true;
      ts.enable = true;
      nix.enable = true;
      # Disabled on Mac: https://github.com/razzmatazz/csharp-language-server/issues/211
      csharp.enable = pkgs.stdenv.isLinux;
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

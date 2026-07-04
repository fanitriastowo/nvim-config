return {
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
  },

  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "elixir",
        "heex",
        "eex",
        "typescript",
        "tsx",
      },
    },
  },

  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g", "z" },
  },

  {
    "https://github.com/nvim-tree/nvim-tree.lua",
    opts = {
      filters = {
        custom = { "^.git$" },
      },
      view = {
        side = "left",
        width = 40,
      },
    },
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require "configs.ibl"
    end,
  },

  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    opts = {
      set_dark_mode = function()
        require("nvconfig").base46.theme = "github_dark"
        require("base46").load_all_highlights()
      end,
      set_light_mode = function()
        require("nvconfig").base46.theme = "github_light"
        require("base46").load_all_highlights()
      end,
      update_interval = 3000,
      fallback = "dark",
    },
  },
}

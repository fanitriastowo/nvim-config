return {
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
      },
    },
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
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require "configs.ibl"
    end,
  },
}

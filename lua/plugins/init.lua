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
        "dart",
      },
    },
    config = function(_, opts)
      -- nvim-treesitter `main` ignores ensure_installed and doesn't enable highlighting itself
      require("nvim-treesitter").install(opts.ensure_installed)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
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
    "nvim-telescope/telescope.nvim",
    opts = function()
      return require "configs.telescope"
    end,
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
        require("nvconfig").base46.theme = "tokyodark"
        require("base46").load_all_highlights()
      end,
      set_light_mode = function()
        require("nvconfig").base46.theme = "flexoki-light"
        require("base46").load_all_highlights()
      end,
      update_interval = 3000,
      fallback = "dark",
    },
  },

  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      image = { enabled = true },
    },
    config = function(_, opts)
      require("snacks").setup(opts)
      -- snacks leaves its "identify loading …" mark behind on the first open of an image; clear it before drawing
      local placement = require "snacks.image.placement"
      local render_grid = placement.render_grid
      placement.render_grid = function(self, loc)
        if not self.opts.inline then
          vim.api.nvim_buf_clear_namespace(self.buf, vim.api.nvim_create_namespace "snacks.image", 0, -1)
          self.eids = {}
        end
        return render_grid(self, loc)
      end
      -- snacks hides an image once its buffer leaves every window, but only un-hides inline (markdown) images.
      -- With tabufline, opening a second image swaps the first out of the window, so it stays blank forever.
      -- Un-hide buffer images when they are shown in a window again.
      local update = placement.update
      placement.update = function(self)
        if self.hidden and not self.opts.inline and #self:wins() > 0 then
          self.hidden = false
        end
        return update(self)
      end
      -- If the image buffer is re-read while it is still loading, snacks closes the old placement, but that
      -- placement's spinner timer only stops on ready(), which is always false once closed. It keeps redrawing
      -- "identify loading …" every 80ms, wiping the image. Same spinner, but it also stops when closed.
      local ns = vim.api.nvim_create_namespace "snacks.image"
      placement.progress = function(self)
        if self.opts.inline or self:ready() then
          return
        end
        vim.bo[self.buf].modifiable = true
        vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, {})
        vim.bo[self.buf].modifiable = false
        vim.bo[self.buf].modified = false -- otherwise closing the buffer asks to save the image
        local timer = assert(vim.uv.new_timer())
        timer:start(
          0,
          80,
          vim.schedule_wrap(function()
            if self.closed or self:ready() or self.img:failed() or not vim.api.nvim_buf_is_valid(self.buf) then
              timer:stop()
              if not timer:is_closing() then
                timer:close()
              end
              return
            end
            vim.api.nvim_buf_clear_namespace(self.buf, ns, 0, -1)
            vim.api.nvim_buf_set_extmark(self.buf, ns, 0, 0, {
              virt_text = {
                { Snacks.util.spinner(), "SnacksImageSpinner" },
                { " " },
                { self.img._convert:current().name .. " loading …", "SnacksImageLoading" },
              },
            })
          end)
        )
      end
      -- When an image's last placement goes away (e.g. closing its buffer), snacks deletes it from the
      -- terminal but still thinks it was sent, so reopening only places an image the terminal no longer has.
      -- Forget it was sent so the next placement transmits it again.
      local image = require "snacks.image.image"
      local del = image.del
      image.del = function(self, pid)
        del(self, pid)
        if not next(self.placements) then
          self.sent = false
        end
      end
    end,
  },
}

require "nvchad.options"

-- add yours here!
local o = vim.o
local is_win = vim.loop.os_uname().sysname == "Windows_NT"

o.cursorlineopt ='both' -- to enable cursorline!
o.breakindent = true
o.showbreak = string.rep(" ", 3)
o.linebreak = true
o.scrolloff = 10
o.smartindent = true
o.colorcolumn = "110"
o.textwidth = 110

if is_win then
  if vim.fn.executable("pwsh") == 1 then
    o.shell = "pwsh"
  else
    o.shell = "powershell"
  end
else
  if vim.fn.executable("zsh") == 1 then
    o.shell = "zsh"
  else
    o.shell = "bash"
  end
end

-- Treesitter-based folding
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Keep folds open by default when opening a file
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true

-- Fix the race condition by setting folding options AFTER the buffer loads.
-- Also force-parse the buffer so foldexpr has a syntax tree to work with.
vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
  pattern = "*",
  callback = function(args)
    vim.schedule(function()
      local ok, parser = pcall(vim.treesitter.get_parser, args.buf)
      if ok and parser then
        parser:parse()
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end
    end)
  end,
})

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

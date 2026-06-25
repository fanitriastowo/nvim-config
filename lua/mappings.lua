require "nvchad.mappings"

-- add yours here

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", {expr = true, silent = true})
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", {expr = true, silent = true})
vim.keymap.set("i", "jk", "<ESC>", { desc = "Escape insert mode" })

vim.keymap.set("n", "<leader>cl", function()
  local path = vim.fn.expand("%:.")
  local line = vim.fn.line(".")
  vim.fn.setreg("+", path .. "#L" .. line)
  print("Copied: " .. path .. "#L" .. line)
end, { desc = "Copy file path and line number" })


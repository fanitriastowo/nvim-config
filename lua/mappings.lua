require "nvchad.mappings"

-- add yours here

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", {expr = true, silent = true})
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", {expr = true, silent = true})

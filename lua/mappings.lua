require "nvchad.mappings"

-- add yours here

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("i", "jk", "<ESC>", { desc = "Escape insert mode" })

vim.keymap.set("n", "<leader>cl", function()
  local path = vim.fn.expand "%:."
  local line = vim.fn.line "."
  vim.fn.setreg("+", path .. "#L" .. line)
  print("Copied: " .. path .. "#L" .. line)
end, { desc = "Copy file path and line number" })

vim.keymap.set("x", "<leader>cl", function()
  local path = vim.fn.expand "%:."
  local start_line = vim.fn.line "v"
  local end_line = vim.fn.line "."
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local result
  if start_line == end_line then
    result = path .. "#L" .. start_line
  else
    result = path .. "#L" .. start_line .. "-" .. end_line
  end
  vim.fn.setreg("+", result)
  print("Copied: " .. result)
end, { desc = "Copy file path and line range" })

vim.keymap.set("n", "zl", "zl", { desc = "Scroll right" })
vim.keymap.set("n", "zh", "zh", { desc = "Scroll left" })
vim.keymap.set("n", "zL", "zL", { desc = "Scroll right half screen" })
vim.keymap.set("n", "zH", "zH", { desc = "Scroll left half screen" })

vim.keymap.set("n", "<leader>>", function()
  require("nvim-tree.api").tree.resize { relative = 5 }
end, { desc = "Widen nvim-tree" })

vim.keymap.set("n", "<leader><", function()
  require("nvim-tree.api").tree.resize { relative = -5 }
end, { desc = "Narrow nvim-tree" })

-- a horizontal line
vim.keymap.set("n", "<leader>=", function()
  local line = vim.api.nvim_get_current_line()
  local count = 80 - #line
  if count < 1 then
    count = 80
  end
  vim.api.nvim_put({ string.rep("=", count) }, "c", true, true)
end, { desc = "Create = line" })

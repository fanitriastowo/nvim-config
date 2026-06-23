require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "ts_ls", "gopls", "goimports" }
vim.lsp.enable(servers)

local lsp_enabled = true

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    if not lsp_enabled then
      client:stop()
      return
    end
    if client.server_capabilities.foldingRangeProvider then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end,
})

vim.diagnostic.config { virtual_text = false }

vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

local function toggle_lsp()
  if lsp_enabled then
    lsp_enabled = false
    for _, client in ipairs(vim.lsp.get_clients()) do
      client:stop()
    end
    vim.diagnostic.reset()
    vim.notify("LSP disabled", vim.log.levels.INFO)
  else
    lsp_enabled = true
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(bufnr) then
        local ft = vim.bo[bufnr].filetype
        if ft ~= "" then
          vim.api.nvim_exec_autocmds("FileType", { buf = bufnr })
          pcall(vim.treesitter.start, bufnr)
        end
      end
    end
    vim.notify("LSP enabled", vim.log.levels.INFO)
  end
end

vim.keymap.set("n", "<leader>tl", toggle_lsp, { desc = "Toggle LSP" })

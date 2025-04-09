vim.g.coq_settings = {
  auto_start = 'shut-up'
}

local lsp = require "lspconfig"
local coq = require "coq"
lsp.ruby_lsp.setup{
  init_options = {
    addonSettings = {
      ["Ruby LSP Rails"] = {
        enablePendingMigrationsPrompt = false
      }
    }
  }
}

require('fzf-lua').setup({'fzf-vim'})

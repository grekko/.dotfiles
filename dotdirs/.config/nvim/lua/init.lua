-- coq v1 (python) breaks on python 3.13+ sqlite named-placeholder strictness.
-- Pin its interpreter to brew python 3.12. Wipe .vars + :COQdeps after changing.
vim.g.python3_host_prog = '/opt/homebrew/bin/python3.12'
vim.g.coq_settings = {
  auto_start = 'shut-up',
  -- ruby_lsp returns completions ~300-600ms, later than the default 166ms auto
  -- timeout. Menu showed early, then re-sorted when LSP landed, resetting the
  -- pmenu selection mid-scroll. Wait longer so the menu is complete + stable
  -- when it first appears. Trade: menu shows a bit later.
  limits = { completion_auto_timeout = 0.5 },
}

local lsp = require "lspconfig"
pcall(require, "coq") -- optional: skip if plugin missing
-- Launch via mise so ruby-lsp runs on the project's ruby (.tool-versions),
-- not whatever ruby was on PATH when nvim started. Wrong ruby = bundler
-- RubyVersionMismatch = ruby_lsp exits 1 = no LSP completions.
lsp.ruby_lsp.setup{
  cmd = { "mise", "exec", "--", "ruby-lsp" },
  init_options = {
    addonSettings = {
      ["Ruby LSP Rails"] = {
        enablePendingMigrationsPrompt = false
      }
    }
  }
}

require('fzf-lua').setup({'fzf-vim'})

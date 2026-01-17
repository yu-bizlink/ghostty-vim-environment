-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 基本設定
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

-- プラグイン設定
require("lazy").setup({
  -- カラースキーム (Catppuccin)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "auto", -- システムのライト/ダークモードに自動対応
        background = {
          light = "latte",
          dark = "mocha",
        },
      })
      vim.cmd.colorscheme "catppuccin"
    end,
  },

  -- LSP設定
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "rust_analyzer", "ts_ls" }
      })

      -- LSP設定
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup{}
      lspconfig.rust_analyzer.setup{}
      lspconfig.ts_ls.setup{}

      -- キーマップ
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
    end,
  },

  -- オートコンプリート
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })
    end,
  },

  -- Treesitter (シンタックスハイライト)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "rust", "javascript", "typescript", "python" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = { theme = "catppuccin" }
      })
    end,
  },

  -- Git統合
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
})

-- キーマップ
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>e', ':Ex<CR>', { desc = 'File explorer' })

print("Neovim initialized for Ghostty Vim environment")

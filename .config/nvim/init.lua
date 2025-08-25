-- ~/.config/nvim/init.lua
-- Main Neovim config using lazy.nvim

-- 1. Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Setup lazy.nvim with plugins
require("lazy").setup({
  -- Colorscheme
  {
    "nyoom-engineering/oxocarbon.nvim",
    config = function()
      vim.cmd.colorscheme("oxocarbon")
    end,
  },

  -- Neo-tree file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    lazy = false,
    config = function()
      require("neo-tree").setup({
        filesystem = { filtered_items = { visible = true } },
        window = { position = "left", width = 30 },
        default_component_configs = {
          name = {
            -- make file open in a new buffer
            bind_to_cwd = false,
            use_expanders = true,
            click_command = "tabnew", -- <- 'edit' opens in current buffer, 'vsplit' for vertical, 'split' for horizontal
          },
        },
      })
    end,
  },
  -- Neogit
  {
    "TimUntersberger/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("neogit").setup {}
    end,
  },

  -- WhichKey
  {
    "folke/which-key.nvim",
    config = function()
      local wk = require("which-key")
      wk.setup()

      wk.add({
        -- File
        { "<leader>f", group = "File" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },

        -- Git
        { "<leader>g", group = "Git" },
        { "<leader>gs", "<cmd>Neogit<cr>", desc = "Status" },
        { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame" },
        { "<leader>gc", "<cmd>Git commit<cr>", desc = "Commit" },
        { "<leader>gp", "<cmd>Git push<cr>", desc = "Push" },
        { "<leader>gP", "<cmd>Git pull<cr>", desc = "Pull" },

        -- Buffers
        { "<leader>b", group = "Buffers" },
        { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer" },
        { "<leader>bn", "<cmd>bnext<cr>", desc = "Next Buffer" },
        { "<leader>bP", "<cmd>bprevious<cr>", desc = "Previous Buffer" },

        -- Notes (Telekasten)
        { "<leader>n", group = "Notes" },
        { "<leader>nn", "<cmd>Telekasten panel<cr>", desc = "Notes Panel" },
        { "<leader>nf", "<cmd>Telekasten find_notes<cr>", desc = "Find Notes" },
        { "<leader>nd", "<cmd>Telekasten goto_today<cr>", desc = "Daily Note" },
        { "<leader>nz", "<cmd>Telekasten follow_link<cr>", desc = "Follow Link" },
        { "<leader>nb", "<cmd>Telekasten show_backlinks<cr>", desc = "Show Backlinks" },
        { "<leader>nt", "<cmd>Telekasten toggle_todo<cr>", desc = "Toggle Todo" },

        -- Obsidian
        { "<leader>o", group = "Obsidian" },
        { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Note" },
        { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open Note" },
        { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch" },
        { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search Notes" },
        { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Insert Template" },

        -- Zettelkasten
        { "<leader>z", group = "Zettelkasten" },
        { "<leader>zn", "<cmd>Telekasten new_note<cr>", desc = "New Note" },
        { "<leader>zl", "<cmd>Telekasten follow_link<cr>", desc = "Follow Link" },
        { "<leader>zb", "<cmd>Telekasten show_backlinks<cr>", desc = "Backlinks" },
        { "<leader>zt", "<cmd>Telekasten toggle_todo<cr>", desc = "Toggle Todo" },
        { "<leader>zf", "<cmd>Telekasten find_notes<cr>", desc = "Find Notes" },
        { "<leader>zd", "<cmd>Telekasten goto_today<cr>", desc = "Daily Note" },
        { "<leader>zz", "<cmd>Telekasten panel<cr>", desc = "Notes Panel" },

        -- Explorer
        { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
      })
    end,
  },

  -- Bufferline.nvim
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup({
        options = {
          numbers = "both", -- shows ordinal + buffer id
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = true,
          show_close_icon = false,
          separator_style = "slant",
          offsets = {
            {
              filetype = "neo-tree",
              text = "Explorer",  -- optional, shows a label
              highlight = "Directory",
              text_align = "left",
            },
          },
        },
      })
    end,
  },

  -- Gitsigns.nvim
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Obsidian.nvim
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/notes",
        },
        {
          name = "no-vault",
          path = function()
            return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
          end,
          overrides = {
            notes_subdir = vim.NIL,
            new_notes_location = "current_dir",
            templates = { folder = vim.NIL },
            disable_frontmatter = true,
          },
        },
      },
    },
  },

  -- Telekasten.nvim
  {
    "renerocksai/telekasten.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require('telekasten').setup({
        home = vim.fn.expand("~/notes"),
      })
    end,
  },

  -- Telescope (dependency for telekasten)
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- LSP
  { "neovim/nvim-lspconfig" },

  -- Autocompletion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },

  -- Lualine
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'cosmicink',
          icons_enabled = true,
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
        },
      }
    end,
  },
})

-- 3. General options
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.conceallevel = 2

-- Set tabs to 2 spaces everywhere
vim.o.tabstop = 2       -- A tab character counts as 2 spaces
vim.o.shiftwidth = 2    -- Indent commands (>> <<) use 2 spaces
vim.o.expandtab = true  -- Convert tabs to spaces

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- 4. Keymaps (non-whichkey)
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "%", "ggVG", { noremap = true, silent = true, desc = "Select entire file" })

-- Load CosmicInk lualine config
require("cosmicink.lualine")


-- ~/.config/nvim/init.lua
-- Fully optimized NVChad-style Neovim config

-- ==============================
-- 1. General editor options
-- ==============================
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.conceallevel = 2

-- Tabs: 2 spaces
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Transparent groups
local transparent_groups = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "NeoTreeNormal",
  "NeoTreeNormalNC",
  "EndOfBuffer",
}
for _, group in ipairs(transparent_groups) do
  vim.api.nvim_set_hl(0, group, { bg = "none" })
end

-- Leader key & non-WhichKey keymaps
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>%", "ggVG", { noremap = true, silent = true, desc = "Select entire file" })

-- ==============================
-- 2. Install & setup lazy.nvim
-- ==============================
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

require("lazy").setup({

  -- ------------------------------
  -- Colorscheme
  -- ------------------------------
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    config = function()
      vim.cmd.colorscheme("oxocarbon")
    end,
  },
  {
    "goolord/alpha-nvim",
    lazy = false, -- eager load for startup screen
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Header: ASCII art or logo
      dashboard.section.header.val = {
        "███╗   ██╗███████╗██╗   ██╗",
        "████╗  ██║██╔════╝██║   ██║",
        "██╔██╗ ██║█████╗  ██║   ██║",
        "██║╚██╗██║██╔══╝  ╚██╗ ██╔╝",
        "██║ ╚████║███████╗ ╚████╔╝",
        "╚═╝  ╚═══╝╚══════╝  ╚═══╝",
      }

      -- Buttons / quick actions
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("n", "  New file", ":ene<CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("t", "  Notes Panel", ":Telekasten panel<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      -- Footer: optional
      dashboard.section.footer.val = "alpha-nvim"

      alpha.setup(dashboard.opts)
    end,
  },
  -- ------------------------------
  -- File Explorer: Neo-tree
  -- ------------------------------
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    cmd = { "Neotree", "NeoTreeToggle" },
    config = function()
      require("neo-tree").setup({
        filesystem = { filtered_items = { visible = true } },
        window = { position = "left", width = 30 },
        default_component_configs = {
          name = { bind_to_cwd = false, use_expanders = true, click_command = "tabnew" },
        },
      })
    end,
  },

  -- ------------------------------
  -- Git integration: Neogit
  -- ------------------------------
  {
    "TimUntersberger/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = "Neogit",
    config = function()
      require("neogit").setup {}
    end,
  },

  -- ------------------------------
  -- WhichKey for leader menus
  -- ------------------------------
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
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

        -- Notes: Telekasten
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

        -- Terminal
        { "<leader>th", "<cmd>lua toggle_horizontal()<CR>", desc = "Horizontal Terminal" },
        { "<leader>tv", "<cmd>lua toggle_vertical()<CR>", desc = "Vertical Terminal" },
        { "<leader>tf", "<cmd>lua toggle_floating()<CR>", desc = "Floating Terminal" },
      })
    end,
  },

  -- ------------------------------
  -- Bufferline
  -- ------------------------------
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = "BufAdd",
    config = function()
      require("bufferline").setup({
        options = {
          numbers = "both",
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = true,
          show_close_icon = false,
          separator_style = "slant",
          offsets = {
            { filetype = "neo-tree", text = "Explorer", highlight = "Directory", text_align = "left" }
          },
        },
      })
    end,
  },

  -- ------------------------------
  -- Gitsigns
  -- ------------------------------
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufRead",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- ------------------------------
  -- Obsidian.nvim
  -- ------------------------------
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "InsertEnter",
    cmd = { "ObsidianNew", "ObsidianOpen", "ObsidianQuickSwitch", "ObsidianSearch", "ObsidianTemplate" },
    opts = {
      workspaces = {
        { name = "notes", path = "~/notes" },
        {
          name = "no-vault",
          path = function() return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0))) end,
          overrides = { notes_subdir = vim.NIL, new_notes_location = "current_dir", templates = { folder = vim.NIL }, disable_frontmatter = true },
        },
      },
    },
  },

  -- ------------------------------
  -- Telekasten.nvim
  -- ------------------------------
  {
    "renerocksai/telekasten.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = { "Telekasten" },
    config = function()
      require('telekasten').setup({ home = vim.fn.expand("~/notes") })
    end,
  },

  -- ------------------------------
  -- Telescope
  -- ------------------------------
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" }, cmd = "Telescope" },

  -- ------------------------------
  -- Treesitter
  -- ------------------------------
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", event = "BufRead" },

  -- ------------------------------
  -- LSP & Autocompletion
  -- ------------------------------
  { "neovim/nvim-lspconfig", lazy=false},
  { "hrsh7th/nvim-cmp", event = "InsertEnter" },
  { "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
  { "L3MON4D3/LuaSnip", event = "InsertEnter" },

  -- ------------------------------
  -- Lualine
  -- ------------------------------
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = "VimEnter",
    config = function()
      require('lualine').setup {
        options = {
          theme = 'cosmicink',
          icons_enabled = true,
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
        },
      }
      require("cosmicink.lualine")
    end,
  },

  -- ------------------------------
  -- Terminal: toggleterm.nvim
  -- ------------------------------
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    event = "VeryLazy",
    config = function()
      local toggleterm = require("toggleterm")
      toggleterm.setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        persist_size = true,
        direction = "float",
        float_opts = { border = "curved", winblend = 0 },
      })

      local Terminal = require("toggleterm.terminal").Terminal
      local horizontal = Terminal:new({ direction = "horizontal", close_on_exit = true })
      local vertical   = Terminal:new({ direction = "vertical", close_on_exit = true })
      local floating   = Terminal:new({ direction = "float", close_on_exit = true })

      function _G.toggle_horizontal() horizontal:toggle() end
      function _G.toggle_vertical()   vertical:toggle() end
      function _G.toggle_floating()   floating:toggle() end
    end,
  },
  -- ------------------------------
  -- Mason & LSP
  -- ------------------------------
  {
    "williamboman/mason.nvim",
    lazy = false,
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    opts = function()
      return {
        ui = { border = "rounded" },
      }
    end,
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        automatic_installation = true,
      })

      local lspconfig = require("lspconfig")

      -- Example: lua_ls for Neovim config
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })
    end,
  },


})


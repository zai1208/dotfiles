-- CosmicInk config for lualine
-- Author: Yeeloman
-- MIT license, see LICENSE for more details.

-- Main configuration for setting up lualine.nvim statusline plugin

-- Default Theme Colors: Define a set of base colors for your theme
local colors = {
  BG = '#16181b', -- Dark background
  FG = '#c5c4c4', -- Light foreground for contrast
  YELLOW = '#e8b75f', -- Vibrant yellow
  CYAN = '#00bcd4', -- Soft cyan
  DARKBLUE = '#2b3e50', -- Deep blue
  GREEN = '#00e676', -- Bright green
  ORANGE = '#ff7733', -- Warm orange
  VIOLET = '#7a3ba8', -- Strong violet
  MAGENTA = '#d360aa', -- Deep magenta
  BLUE = '#4f9cff', -- Light-medium blue
  RED = '#ff3344', -- Strong red
}

-- Function to get the color associated with the current mode in Vim
local function get_mode_color()
  local mode_color = {
    n = colors.DARKBLUE,
    i = colors.VIOLET,
    v = colors.RED,
    [''] = colors.BLUE,
    V = colors.RED,
    c = colors.MAGENTA,
    no = colors.RED,
    s = colors.ORANGE,
    S = colors.ORANGE,
    [''] = colors.ORANGE,
    ic = colors.YELLOW,
    R = colors.ORANGE,
    Rv = colors.ORANGE,
    cv = colors.RED,
    ce = colors.RED,
    r = colors.CYAN,
    rm = colors.CYAN,
    ['r?'] = colors.CYAN,
    ['!'] = colors.RED,
    t = colors.RED,
  }
  return mode_color[vim.fn.mode()]
end

-- Function to get the opposite color of a given mode color
local function get_opposite_color(mode_color)
  local opposite_colors = {
    [colors.RED] = colors.CYAN,
    [colors.BLUE] = colors.ORANGE,
    [colors.GREEN] = colors.MAGENTA,
    [colors.MAGENTA] = colors.DARKBLUE,
    [colors.ORANGE] = colors.BLUE,
    [colors.CYAN] = colors.YELLOW,
    [colors.VIOLET] = colors.GREEN,
    [colors.YELLOW] = colors.RED,
    [colors.DARKBLUE] = colors.VIOLET,
  }
  return opposite_colors[mode_color] or colors.FG
end

-- Function to interpolate between two colors for a smooth transition
local function interpolate_color(color1, color2, step)
  local blend = function(c1, c2, stp)
    return math.floor(c1 + (c2 - c1) * stp)
  end
  local r1, g1, b1 = tonumber(color1:sub(2, 3), 16), tonumber(color1:sub(4, 5), 16), tonumber(color1:sub(6, 7), 16)
  local r2, g2, b2 = tonumber(color2:sub(2, 3), 16), tonumber(color2:sub(4, 5), 16), tonumber(color2:sub(6, 7), 16)
  local r = blend(r1, r2, step)
  local g = blend(g1, g2, step)
  local b = blend(b1, b2, step)
  return string.format('#%02X%02X%02X', r, g, b)
end

-- Function to get a middle color by interpolating between mode color and its opposite
local function get_middle_color(color_step)
  color_step = color_step or 0.5
  local color1 = get_mode_color()
  local color2 = get_opposite_color(color1)
  return interpolate_color(color1, color2, color_step)
end

-- Condition: Hide in width (only show the statusline when the window width is greater than 80)
local function hide_in_width()
  return vim.fn.winwidth(0) > 80
end

-- Function to create a separator component based on side (left/right) and optional mode color
local function create_separator(side, use_mode_color)
  return {
    function()
      return side == 'left' and '' or ''
    end,
    color = function()
      local color = use_mode_color and get_mode_color() or get_opposite_color(get_mode_color())
      return { fg = color }
    end,
    padding = { left = 0 },
  }
end

-- Function to create a mode-based component
local function create_mode_based_component(content, icon, color_fg, color_bg)
  return {
    content,
    icon = icon,
    color = function()
      local mode_color = get_mode_color()
      local opposite_color = get_opposite_color(mode_color)
      return {
        fg = color_fg or colors.FG,
        bg = color_bg or opposite_color,
        gui = 'bold',
      }
    end,
  }
end

-- Function to get the current mode indicator as a single character
local function mode()
  local mode_map = {
    n = 'N', i = 'I', v = 'V', [''] = 'V', V = 'V',
    c = 'C', no = 'N', s = 'S', S = 'S', ic = 'I',
    R = 'R', Rv = 'R', cv = 'C', ce = 'C', r = 'R',
    rm = 'M', ['r?'] = '?', ['!'] = '!', t = 'T',
  }
  return mode_map[vim.fn.mode()] or '[UNKNOWN]'
end

-- Config
local config = {
  options = {
    component_separators = '',
    section_separators = '',
    theme = {
      normal = { c = { fg = colors.FG, bg = colors.BG } },
      inactive = { c = { fg = colors.FG, bg = colors.BG } },
    },
    disabled_filetypes = { 'neo-tree', 'undotree', 'sagaoutline', 'diff' },
  },
  sections = { lualine_a = {}, lualine_b = {}, lualine_c = {}, lualine_x = {}, lualine_y = {}, lualine_z = {} },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'location',
        color = { fg = colors.FG, gui = 'bold' },
      },
    },
    lualine_x = {
      {
        'filename',
        color = { fg = colors.FG, gui = 'bold,italic' },
      },
    },
    lualine_y = {},
    lualine_z = {},
  },
}

-- Helper functions
local function ins_left(component) table.insert(config.sections.lualine_c, component) end
local function ins_right(component) table.insert(config.sections.lualine_x, component) end

-- LEFT
ins_left {
  mode,
  color = function() return { fg = colors.BG, bg = get_mode_color(), gui = 'bold' } end,
  padding = { left = 1, right = 1 },
}

ins_left(create_separator('left', true))

ins_left {
  function() return vim.fn.fnamemodify(vim.fn.getcwd(), ':t') end,
  icon = ' ',
  color = function()
    local virtual_env = vim.env.VIRTUAL_ENV
    if virtual_env then
      return { fg = get_mode_color(), gui = 'bold,strikethrough' }
    else
      return { fg = get_mode_color(), gui = 'bold' }
    end
  end,
}

ins_left(create_separator('right'))

ins_left(create_mode_based_component('filename', nil, colors.BG))

ins_left(create_separator('left'))

ins_left {
  function() return '' end,
  color = function() return { fg = get_middle_color() } end,
  cond = hide_in_width,
}

ins_left {
  function()
    local git_status = vim.b.gitsigns_status_dict
    if git_status then
      return string.format('+%d ~%d -%d', git_status.added or 0, git_status.changed or 0, git_status.removed or 0)
    end
    return ''
  end,
  color = { fg = colors.YELLOW, gui = 'bold' },
  cond = hide_in_width,
}

ins_left { 'searchcount', color = { fg = colors.GREEN, gui = 'bold' } }

-- RIGHT
ins_right {
  function()
    local reg = vim.fn.reg_recording()
    return reg ~= '' and '[' .. reg .. ']' or ''
  end,
  color = { fg = colors.RED, gui = 'bold' },
  cond = function() return vim.fn.reg_recording() ~= '' end,
}

ins_right { 'selectioncount', color = { fg = colors.GREEN, gui = 'bold' } }

ins_right {
  function()
    local msg = 'No Active Lsp'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then return msg end
    local lsp_short_names = { pyright = 'py', tsserver = 'ts', rust_analyzer = 'rs', lua_ls = 'lua', clangd = 'c++', bashls = 'sh', jsonls = 'json', html = 'html', cssls = 'css', tailwindcss = 'tw', dockerls = 'docker', sqlls = 'sql', yamlls = 'yml' }
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return lsp_short_names[client.name] or client.name:sub(1, 2)
      end
    end
    return msg
  end,
  icon = ' ',
  color = { fg = colors.YELLOW, gui = 'bold' },
}

ins_right {
  function() return '' end,
  color = function() return { fg = get_middle_color() } end,
  cond = hide_in_width,
}

ins_right(create_separator('right'))

ins_right(create_mode_based_component('location', nil, colors.BG))

ins_right(create_separator('left'))

ins_right {
  'branch',
  icon = ' ',
  fmt = function(branch)
    if branch == '' or branch == nil then return 'No Repo' end
    local function truncate_segment(segment, max_length)
      if #segment > max_length then return segment:sub(1, max_length) end
      return segment
    end
    local segments = {}
    for segment in branch:gmatch('[^/]+') do table.insert(segments, segment) end
    for i = 1, #segments - 1 do segments[i] = truncate_segment(segments[i], 1) end
    if #segments == 1 then return segments[1] end
    segments[1] = segments[1]:upper()
    for i = 2, #segments - 1 do segments[i] = segments[i]:lower() end
    local truncated_branch = table.concat(segments, '', 1, #segments - 1) .. '›' .. segments[#segments]
    if #truncated_branch > 15 then truncated_branch = truncated_branch:sub(1, 15) .. '…' end
    return truncated_branch
  end,
  color = function() return { fg = get_mode_color(), gui = 'bold' } end,
}

ins_right(create_separator('right'))

ins_right(create_mode_based_component('progress', nil, colors.BG))

require('lualine').setup(config)


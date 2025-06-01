-- telescope.lua
-- author: peterm
-- created: 2025-05-31
--  _____  ___  _     ___  ___   ___  ___   ___  ___ 
-- |_   _|| __|| |   | __|/ __| / __|/ _ \ | _ \| __|
--   | |  | _| | |__ | _| \__ \| (__| (_) ||  _/| _| 
--   |_|  |___||____||___||___/ \___|\___/ |_|  |___|
--                                                   
-------------------------------------------------------------
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 
      { "nvim-tree/nvim-web-devicons", opts = true }
  },

  opts = {
      options = {
          icons_enabled = false,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
  },
  sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = {
          {
              'filename',
              path = 1,
          }
      },
      lualine_x = {
          {
              'diagnostics',
              symbols = { error = 'X:', warn = '!:', info = 'i:', hint = '?:' },
              always_visible = true,
          }
      },
      lualine_y = { 'location' },
      lualine_z = { 'encoding' },
  },
  inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
 }
}

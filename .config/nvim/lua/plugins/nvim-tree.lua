return {
  'nvim-tree/nvim-tree.lua',
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = { 
        sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  },
  init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
  end,
}

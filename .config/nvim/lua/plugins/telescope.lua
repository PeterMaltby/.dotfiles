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
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
-- or                              , branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {     
      { "<F5>", "<cmd>Telescope git_files<cr>", desc = "git file search" },
      { "<F6>", "<cmd>Telescope live_grep<cr>", desc = "grep file search" },
      { "<F7>", "<cmd>Telescope find_files<cr>", desc = "find a file" },
      { "<F8>", "<cmd>Telescope grep_string<cr>", desc = "find string under cursor" },
  }
}

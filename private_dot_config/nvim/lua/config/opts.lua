--
-- opts
-- 

local o = vim.opt

o.number = true
o.syntax = "on"
o.relativenumber = true

o.clipboard = "unnamedplus"
o.autoindent = true
o.cursorline = true
o.lazyredraw = true
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.encoding = "UTF-8"
o.ruler = true
o.mouse = "a"
o.mousescroll = "ver:1"
o.title = true
o.titlelen = 0
o.hidden = true
o.timeoutlen = 1000
o.wildmenu = true
o.showcmd = true
o.showmatch = true
o.inccommand = "split"
o.splitright = true
o.splitbelow = true
o.termguicolors = true
o.smarttab = true
o.shell = "zsh"
o.hlsearch = true
o.ignorecase = true
o.wrap = false
o.backspace = { "start", "eol", "indent" }
o.titlestring = 'Neovim: %{expand(\"%:p\")} [%{mode()}]'

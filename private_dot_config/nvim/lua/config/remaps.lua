--
-- remaps
--

local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { silent = true })
end

local function mapn(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true })
end

vim.api.nvim_set_keymap("", ";", "<Nop>", { noremap = true, silent = true })

map("", ";", "<Nop>")

vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

map("n", "<leader>a", function() print "hi" end)

-- New Windows
map("n", "<Leader>o", "<CMD>vsplit<CR>")
-- lmap("n", "<Leader>p", "<CMD>split<CR>")

-- Resize Windows
map("n", "<C-S-Left>", "5<C-w>>")
map("n", "<C-S-Right>", "5<C-w><")
map("n", "<C-S-Up>", "<C-w>-")
map("n", "<C-S-Down>", "<C-w>+")

-- Move to previous/next
mapn('n', '<A-,>', '<Cmd>BufferPrevious<CR>')
mapn('n', '<A-.>', '<Cmd>BufferNext<CR>')

-- Re-order to previous/next
mapn('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>')
mapn('n', '<A->>', '<Cmd>BufferMoveNext<CR>')

-- Goto buffer in position...
mapn('n', '<A-1>', '<Cmd>BufferGoto 1<CR>')
mapn('n', '<A-2>', '<Cmd>BufferGoto 2<CR>')
mapn('n', '<A-3>', '<Cmd>BufferGoto 3<CR>')
mapn('n', '<A-4>', '<Cmd>BufferGoto 4<CR>')
mapn('n', '<A-5>', '<Cmd>BufferGoto 5<CR>')
mapn('n', '<A-6>', '<Cmd>BufferGoto 6<CR>')
mapn('n', '<A-7>', '<Cmd>BufferGoto 7<CR>')
mapn('n', '<A-8>', '<Cmd>BufferGoto 8<CR>')
mapn('n', '<A-9>', '<Cmd>BufferGoto 9<CR>')
mapn('n', '<A-0>', '<Cmd>BufferLast<CR>')

mapn('n', '<C-p>', '<Cmd>BufferPick<CR>')

-- Window Navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-j>", "<C-w>j")

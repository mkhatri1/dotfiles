--
-- remaps
--

local function map(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { silent = true, noremap = true }, opts or {}))
end

-- New Windows
map("n", "<Leader>o", "<CMD>vsplit<CR>")
map("n", "<Leader>p", "<CMD>split<CR>")

-- Resize Windows
map("n", "<C-S-h>", "5<C-w>>")
map("n", "<C-S-l>", "5<C-w><")
map("n", "<C-S-k>", "<C-w>-")
map("n", "<C-S-j>", "<C-w>+")

-- Window Navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-j>", "<C-w>j")

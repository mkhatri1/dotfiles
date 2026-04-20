--
-- opts
--

local o = vim.opt

o.number = true
o.relativenumber = true

o.clipboard = "unnamedplus"
o.autoindent = true
o.cursorline = true
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.ruler = true
o.mouse = "a"
o.mousescroll = "ver:1"
o.title = true
o.titlelen = 0
o.hidden = true
o.timeoutlen = 500
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
o.smartcase = true
o.wrap = false
o.backspace = { "start", "eol", "indent" }
o.titlestring = 'Neovim: %{expand("%:p")} [%{mode()}]'
o.selection = 'exclusive'
o.scrolloff = 8
o.sidescrolloff = 8

-- Keep this dir out of source control; files contain deleted text.
o.undofile = true
o.undodir = vim.fn.stdpath("data") .. "/undo"

-- Disable undo persistence for sensitive files
vim.api.nvim_create_autocmd("BufReadPre", {
    callback = function(args)
        local file = args.file
        local sensitive = {
            "/tmp/", "/private/tmp/",       -- temp files
            "/%.ssh/", "/%.gnupg/",         -- credentials
            "%.gpg$", "%.age$", "%.enc$",   -- encrypted files
            "%.pem$", "%.key$", "%.p12$",   -- certs / keys
            "COMMIT_EDITMSG", "MERGE_MSG",  -- git messages
            "%.env$", "%.secret$",          -- env / secret files
        }
        for _, pat in ipairs(sensitive) do
            if file:find(pat) then
                vim.opt_local.undofile = false
                return
            end
        end
    end,
})

-- Modern diagnostic signs (Neovim 0.10+)
vim.diagnostic.config({
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
            [vim.diagnostic.severity.HINT]  = "󰌵 ",
        },
    },
})

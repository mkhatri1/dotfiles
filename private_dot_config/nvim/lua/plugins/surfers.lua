return {
        'fpeterek/nvim-surfers',
        cmd = "Surf",
        config = function()
            require('nvim-surfers').setup({
                use_tmux = true,
            })
        end
    }


alias rl="exec zsh"
alias n=nvim
alias vi=nvim
alias pm=pnpm
alias tf="tofu"
alias ch="chezmoi"

alias zp="cd ~/.zsh"
alias vc="vim ~/.vimrc"
alias pkey="cat ~/.ssh/id_ed25519.pub | pbcopy"
alias tconf="tmuxconf"
alias vp="cd ~/.config/nvim/lua/plugins"
alias wp="cd ~/workspace"

# `eza` = more configurable `ls`
alias ls="eza -s type"
# config to make scp transfers faster
alias scpf="scp -p -C -o 'CompressionLevel 9' -o 'IPQoS throughput' -c aes128-ctr"


alias thelp="echo 'Alias	Command	Description
ta	tmux attach -t	Attach new tmux session to already running named session
tad	tmux attach -d -t	Detach named tmux session
tds	_tmux_directory_session	Creates or attaches to a session for the current path
tkss	tmux kill-session -t	Terminate named running tmux session
tksv	tmux kill-server	Terminate all running tmux sessions
tl	tmux list-sessions	Displays a list of running tmux sessions
tmux	_zsh_tmux_plugin_run	Start a new tmux session
tmuxconf	$EDITOR $ZSH_TMUX_CONFIG	Open .tmux.conf file with an editor
ts	tmux new-session -s	Create a new named tmux session'"



# bun completions
[ -s "/Users/mkhatri/.bun/_bun" ] && source "/Users/mkhatri/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# add Pulumi to the PATH
export PATH=$PATH:/home/mkhatri/.pulumi/bin

source ~/.zsh/_machine-config.zsh
source ~/.zsh/secrets.zsh
source ~/.zsh/init.zsh
source ~/.zsh/aliases.zsh

if [[ $MACHINE_IS_WORK == true ]]; then
    source ~/.zsh/work.zsh
fi

source ~/.zsh/utilities.zsh

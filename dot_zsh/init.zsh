# Init profiling
zmodload zsh/zprof

export TERM=xterm-256color
export SHELL="/bin/zsh"
export EDITOR="nvim"

zmodload -i zsh/complist
zstyle ":completion:*" matcher-list 'm:{a-zA-Z}={A-Za-z}'
# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -Uz +X bashcompinit
bashcompinit
# Initialize completion functionality early so zinit can backtrack later
() {
	setopt local_options
	setopt extendedglob

	local zcd=${1}
	local zcomp_hours=${2:-24} # how often to regenerate the file
	local lock_timeout=${2:-1} # change this if compinit normally takes longer to run
	local lockfile=${zcd}.lock

	if [ -f ${lockfile} ]; then 
		if [[ -f ${lockfile}(#qN.mm+${lock_timeout}) ]]; then
			(
				echo "${lockfile} has been held by $(< ${lockfile}) for longer than ${lock_timeout} minute(s)."
				echo "This may indicate a problem with compinit"
			) >&2 
		fi
		# Exit if there's a lockfile; another process is handling things
		return
	else
		# Create the lockfile with this shell's PID for debugging
		echo $$ > ${lockfile}
		# Ensure the lockfile is removed
		trap "rm -f ${lockfile}" EXIT
	fi

	autoload -Uz compinit

	if [[ -n ${zcd}(#qN.mh+${zcomp_hours}) ]]; then
		# The file is old and needs to be regenerated
		compinit
	else
		# The file is either new or does not exist. Either way, -C will handle it correctly
		compinit -C
	fi
} ${ZDOTDIR:-$HOME}/.zcompdump 
#
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# END Zinit install block

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Load P10K
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Figure out the SHORT hostname
if [[ "$OSTYPE" = darwin* ]]; then
  # macOS's $HOST changes with dhcp, etc. Use ComputerName if possible.
  export SHORT_HOST=$(scutil --get ComputerName 2>/dev/null) || SHORT_HOST="${HOST/.*/}"
else
  export SHORT_HOST="${HOST/.*/}"
fi

#test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
#export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES

export GPG_TTY=$(tty)
export PATH="$PATH:$HOME/.local/bin"

zinit ice depth=1
zinit load mroth/evalcache

## Autosuggestions / Format

ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
zinit ice wait="0a" lucid atload="_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# Zoxide (Improved CD with fuzzy finder)
zinit ice wait="0" lucid from="gh-r" as="program" pick="zoxide-*/zoxide -> zoxide" cp="zoxide-*/completions/_zoxide -> _zoxide" atclone="./zoxide init --cmd cd zsh > init.zsh" atpull="%atclone" src="init.zsh"
zinit light ajeetdsouza/zoxide

# Tree-Sitter
zinit ice as="program" from="gh-r" mv="tree* -> tree-sitter" pick="tree-sitter"
zinit light tree-sitter/tree-sitter

# Syntax Highlighting
zinit ice wait"0c" lucid atinit="zicompinit; zicdreplay" src"zsh-syntax-highlighting.zsh"
zinit light zsh-users/zsh-syntax-highlighting

## UTILITY PROGRAMS

# FZF
zinit ice from="gh-r" as="command"
zinit light junegunn/fzf
# FZF BYNARY AND TMUX HELPER SCRIPT
zinit ice lucid wait'0c' as="command" id-as="junegunn/fzf-tmux" pick="bin/fzf-tmux"
zinit light junegunn/fzf
# BIND MULTIPLE WIDGETS USING FZF
zinit ice lucid wait'0c' multisrc"shell/{completion,key-bindings}.zsh" id-as="junegunn/fzf_completions" pick="/dev/null"
zinit light junegunn/fzf
# FZF-TAB
zinit ice wait="1" lucid
zinit light Aloxaf/fzf-tab
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# PRETTYPING
zinit ice lucid wait="" as="program" pick="prettyping" atload="alias ping=prettyping"
zinit load denilsonsa/prettyping

# EZA (Improved LS with formatting)
export EZA_COLORS="di=36;1:uu=2;33:da=94"
zinit ice wait="2" lucid from="gh-r" as="program" mv="bin/eza* -> eza" atload="alias ls='eza --git  --classify --group-directories-first --time-style=long-iso --group --color-scale'"
zinit light eza-community/eza

# Delta
zinit ice lucid wait="0" as="program" from="gh-r" pick="delta*/delta"
zinit light dandavison/delta

# DUF
zinit ice lucid wait="0" as="program" from="gh-r" atload="alias df=duf"
zinit light muesli/duf

# RIPGREP
zinit ice from="gh-r" as="program" mv="ripgrep* -> ripgrep" pick="ripgrep/rg"
zinit light BurntSushi/ripgrep

# JQ
zinit ice lucid from="gh-r" nocompile sbin="* -> jq"
zinit light @jqlang/jq

# LazyDocker
zinit ice lucid wait as="program" from="gh-r" mv="lazydocker* -> lazydocker" atload="alias ld='lazydocker'"
zinit light jesseduffield/lazydocker

# ZSH Integration TMUX
zinit ice wait lucid depth"1"
zinit snippet https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/plugins/tmux/tmux.plugin.zsh

# LazyGit
zinit ice wait="2" lucid from="gh-r" as="program" sbin="**/lazygit" atload="alias lg='lazygit'" 
zinit light jesseduffield/lazygit

# Glow - MD Reader
zinit wait lucid for from="gh-r" sbin="**/glow" charmbracelet/glow

## CORE PROGRAMS

# NEOVIM
zinit ice lucid wait from="gh-r" as="program" ver="stable" pick"./*/*/nvim" atload="alias vim='nvim'"
zinit light neovim/neovim

# GitHub-CLI
zinit ice lucid wait="0" as="program" from="gh-r" pick="gh*/bin/gh"
zinit light cli/cli

# NVM 
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
export NVM_AUTO_USE=true
export NVM_COMPLETION=true
export NVM_SYMLINK_CURRENT="true"

zinit ice wait lucid depth"1"
zinit load lukechilds/zsh-nvm

alias node='unalias node ; unalias npm ; nvm use default ; node $@'
alias npm='unalias node ; unalias npm ; nvm use default ; npm $@'

# PyEnv
zinit ice atclone'PYENV_ROOT="$PWD" ./libexec/pyenv init - > zpyenv.zsh' \
    atinit'export PYENV_ROOT="$PWD"' atpull"%atclone" \
    as'command' pick'bin/pyenv' src"zpyenv.zsh" nocompile'!'
zinit light pyenv/pyenv

# TMUX
zinit id-as for \
    cmake \
  @thewtex/tmux-mem-cpu-load \
    configure'--disable-utf8proc' make \
  @tmux/tmux

## Complete Initialization
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

## History configuration
SAVEHIST=1000000
HISTSIZE=1000000

## ZSH opt configuration
HISTFILE=~/.zsh_history
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
unsetopt HIST_BEEP                 # Beep when accessing nonexistent history.
setopt COMPLETE_IN_WORD
setopt LIST_AMBIGUOUS
setopt AUTOMENU
setopt HASH_LIST_ALL
# Better history
# Credits to https://coderwall.com/p/jpj_6q/zsh-better-history-searching-with-arrow-keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

bindkey "\ef" forward-word
bindkey "\eb" backward-word
bindkey "\ed" kill-word
bindkey "\eD" kill-word
bindkey "^[d" kill-word
bindkey "^[^H" backward-kill-word
bindkey "^[^?" backward-kill-word

_evalcache pulumi gen-completion zsh

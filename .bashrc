#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
alias grep='grep --color=auto'

export HISTSIZE=10000
export HISTFILESIZE=10000

# PS1='[\u@\h \W]\$ '
PS1="\[\e[32m\][\[\e[m\]\[\e[31m\]\u\[\e[m\]@\[\e[32m\]\h \[\e[m\]\[\e[33m\]\w\[\e[m\]\[\e[32m\]]\[\e[m\]\\$ "

stty -ixon  # Disable Ctrl-S and Ctrl-Q
shopt -s autocd

# fzf integration
eval "$(fzf --bash)"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
	local command=$1
	shift

	case "$command" in
		cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
		export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
		ssh)          fzf --preview 'dig {}'                   "$@" ;;
		*)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
	esac
}

# yazi: provides the ability to change the current working directory when exiting
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

## Node version manager
# lazy_load_nvm() {
#   unset -f node nvm
# 	export NVM_DIR="$HOME/.nvm"
#   [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
# }
# node() {
#   lazy_load_nvm
#   node $@
# }
# nvm() {
#   lazy_load_nvm
#   node $@
# }


alias ..='cd ..'
alias ...='cd ../..'
alias cls='clear'

alias sudo='sudo -E'

alias rm='rm -i'
alias mv='mv -i'

alias ls='eza'
alias ll='eza -lah --group-directories-first --color=always --icons=always --git'

alias v='vim'
alias sv='sudo vim'

alias gs='git status'
alias gc='git clone --depth=1'

alias ff='fastfetch'
alias icat='kitten icat'
alias cloc='tokei'
alias pyserve='python -m http.server'
alias tl="tldr --list | fzf --preview 'tldr {} --color always' | xargs tldr"
alias pwr='echo "$(energy1=$(sudo cat /sys/class/powercap/intel-rapl:0/energy_uj)
	sleep 1; energy2=$(sudo cat /sys/class/powercap/intel-rapl:0/energy_uj)
	echo "scale=6; ($energy2 - $energy1) / 1000000" | bc | sed "s/^-//") watts"'
alias wttr='curl wttr.in/?nQF1'


export EDITOR=vim
export MANPAGER='vim -M +MANPAGER "+set ft=man" -'

export PATH="$HOME/scripts:$HOME/.config/emacs/bin:$PATH"

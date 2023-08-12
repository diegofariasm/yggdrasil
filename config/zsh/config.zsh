# Stop TRAMP (in Emacs) from hanging or term/shell from echoing back commands
if [[ $TERM == dumb || -n $INSIDE_EMACS ]]; then
  unsetopt zle prompt_cr prompt_subst
  whence -w precmd >/dev/null && unfunction precmd
  whence -w preexec >/dev/null && unfunction preexec
  PS1='$ '
fi

## Plugins
# zgen
# we handle compinit ourselves...
export ZGEN_AUTOLOAD_COMPINIT=0

# zsh-vi-mode
export ZVM_INIT_MODE=sourcing
export ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

# fasd
export _FASD_DATA="$XDG_CACHE_HOME/fasd"
export _FASD_VIMINFO="$XDG_CACHE_HOME/viminfo"

# fzf
if (( $+commands[fd] )); then
  export FZF_DEFAULT_OPTS="--reverse --ansi"
  export FZF_DEFAULT_COMMAND="fd ."
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd -t d . $HOME"
fi



eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

[[ -f ~/.Xresources  ]] && xrdb -merge -I$HOME ~/.Xresources
exec dwm

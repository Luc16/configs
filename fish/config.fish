# Enable Vi key bindings
alias oldvim="vim"
alias vim="nvim"
alias vi="nvim"


fish_vi_key_bindings

# Set cursor shapes for different modes
set fish_cursor_default block      # Normal mode: block cursor
set fish_cursor_insert line        # Insert mode: line cursor
set fish_cursor_visual block       # Visual mode: block cursor
set fish_cursor_replace underscore # Replace mode: underscore cursor
set fish_cursor_replace_one underscore
set fish_cursor_external line      # External commands: line cursor

bind \cl ''

set -x QT_QPA_PLATFORM wayland


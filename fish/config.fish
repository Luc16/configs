# Enable Vi key bindings
alias oldvim="vim"
alias vim="nvim"
alias vi="nvim"
alias vid='nvim --cmd "let g:SHOULD_OPEN_DASHBOARD=1"'
alias v="nvim"
alias vd='nvim --cmd "let g:SHOULD_OPEN_DASHBOARD=1"'

fish_add_path /home/luc/Documents/Mestrado/llvm-project/build/bin
fish_add_path /usr/local/cuda-12.2/bin/
# fish_add_path /opt/riscv/bin
# fish_add_path /opt/riscv/bin/bin/
# fish_add_path /opt/riscv/riscv64-unknown-elf/bin

# set LD_LIBRARY_PATH /usr/local/cuda-12.2/lib64$LD_LIBRARY_PATH
set LD_LIBRARY_PATH /usr/local/cuda-12.2/lib64 $LD_LIBRARY_PATH

fish_vi_key_bindings

# Set cursor shapes for different modes
set fish_cursor_default block      # Normal mode: block cursor
set fish_cursor_insert line        # Insert mode: line cursor
set fish_cursor_visual block       # Visual mode: block cursor
set fish_cursor_replace underscore # Replace mode: underscore cursor
set fish_cursor_replace_one underscore
set fish_cursor_external line      # External commands: line cursor

bind \cl ''

# set -x QT_QPA_PLATFORM wayland
set -x QT_QPA_PLATFORM xcb

starship init fish | source

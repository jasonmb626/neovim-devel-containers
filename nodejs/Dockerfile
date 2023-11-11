FROM node:21-alpine3.17

ARG RUN_ENV

RUN adduser -D dev 

USER root

RUN if [ "$RUN_ENV" = "DEV" ]; then \
        apk add git\
             stylua\
             npm\
             lua-dev luarocks\
             lazygit\
             tmux neovim neovim-doc py3-pynvim\
             procps\
             ripgrep\
             alpine-sdk\
             tree-sitter tree-sitter-cli\
             fd\ 
             wl-clipboard\
             sudo\
             --update;\
        echo 'dev ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/dev;\
    fi

USER dev
RUN if [ "$RUN_ENV" = "DEV" ]; then \
        mkdir -p /home/dev/.local/share/nvim; mkdir -p /home/dev/.config/tmux;\
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm;\
    fi

WORKDIR /app

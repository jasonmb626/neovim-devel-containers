FROM python:3.9.18-alpine

ARG RUN_ENV

RUN apk add git --update

RUN adduser -D dev

USER dev

RUN mkdir -p /home/dev/.local/share/nvim
RUN mkdir -p /home/dev/.config/tmux

RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

USER root
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt && rm /tmp/requirements.txt

RUN if [ "$RUN_ENV" = "DEV" ]; then \
    apk add stylua\
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
             --update;\
    fi

USER dev

EXPOSE 3000

WORKDIR /app

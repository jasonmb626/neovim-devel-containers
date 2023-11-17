FROM node:21-alpine3.17

ARG RUN_ENV
ARG SSH_KEYS

RUN apk add git --update

RUN adduser -D dev 

RUN mkdir -p /home/dev/.ssh
COPY ssh/id_rsa* /home/dev/.ssh
RUN touch /home/dev/.ssh/config; chown -R dev:dev /home/dev/.ssh; chmod 400 /home/dev/.ssh/config;
RUN touch /home/dev/.gitconfig; chown -R dev:dev /home/dev/.gitconfig

COPY requirements-dev.txt /tmp/requirements-dev.txt
RUN if [ "$RUN_ENV" == "DEV" ]; then \
    apk add stylua\
             npm\
             openssh\
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
    echo -e "Host *\n    StrictHostKeyChecking no" > /home/dev/.ssh/config;\
    echo 'dev ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/dev;\
fi

USER dev
RUN if [ "$RUN_ENV" == "DEV" ]; then \
    mkdir -p /home/dev/.local/share/nvim; mkdir -p /home/dev/.config/tmux;\
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm;\
    echo -e "[user]\n	email = jason@jasonbrunelle.com\n	name = Jason Brunelle\n[init]\n	defaultBranch = main\n[pull]	rebase = false" >/home/dev/.gitconfig;\
else\
    rm -fr /home/dev/.ssh;\
fi

WORKDIR /app

###############################     Base    #################################################
FROM node:21-alpine3.18 as prod

WORKDIR /app
COPY app/. .

#These (esp the LANG variable) make sure tmux outputs UTF-8. Needed for special chars
ENV GDM_LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN if [[ -s package.json ]]; then\
        npm install;\
    fi

CMD ["node", "app.js"]

#############################   Development   ################################################
FROM prod as dev

RUN mkdir -p /home/node/.ssh \
    && chown node:node /home/node/.ssh \
    && touch /home/node/.ssh/config \
    && chown -R node:node /home/node/.ssh \
    && touch /home/node/.gitconfig \
    && chown -R node:node /home/node/.gitconfig \
    && mkdir -p /home/node/.local/share/nvim \
    && chown -R node:node /home/node/.local/share/nvim \
    && mkdir -p /home/node/.config/tmux \
    && chown -R node:node /home/node/.config/tmux \
    && mkdir -p /home/node/.config/lazygit \
    && touch /home/node/.config/lazygit/config.yml \
    && chown -R node:node /home/node/.config/lazygit \
    && apk add git\ 
         lua-dev luarocks\
         lazygit\
         tmux neovim neovim-doc\
         procps\
         tmux\
         ripgrep\
         alpine-sdk\
         tree-sitter tree-sitter-cli\
         fd\ 
         wl-clipboard\
         sudo \
    && mkdir -p /etc/sudoers.d && echo 'node ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/node \
    && git clone https://github.com/tmux-plugins/tpm /home/node/.tmux/plugins/tpm \
    && echo -e "[user]\n	email = jasonmb626@gmail.com\n	name = Jason Brunelle\n[init]\n	defaultBranch = main\n[pull]	rebase = false" >/home/node/.gitconfig \
    && echo -e "Host *\n    StrictHostKeyChecking no" > /home/node/.ssh/config \
    && chmod 400 /home/node/.ssh/config

CMD ["tmux"]

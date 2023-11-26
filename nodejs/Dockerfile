###############################     Base    #################################################
FROM node:21-alpine3.18 as prod

ARG UID=1000
ARG GID=1000

RUN deluser --remove-home node \
    && addgroup -g ${GID} dev \
    && adduser -D -u ${UID} -G dev -s /bin/bash dev \
    && mkdir -p /home/dev/.config \
    && chown dev:dev /home/dev/.config

USER dev
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

USER root

RUN mkdir -p /home/dev/.config/lazygit \
    && touch /home/dev/.config/lazygit/config.yml \
    && chown -R dev:dev /home/dev/.config/lazygit \
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
    && mkdir -p /etc/sudoers.d && echo 'dev ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/dev

USER dev
RUN git clone https://github.com/tmux-plugins/tpm /home/dev/.tmux/plugins/tpm \
    && echo -e "[user]\n	email = jasonmb626@gmail.com\n	name = Jason Brunelle\n[init]\n	defaultBranch = main\n[pull]	rebase = false" >/home/dev/.gitconfig \

CMD ["tmux"]

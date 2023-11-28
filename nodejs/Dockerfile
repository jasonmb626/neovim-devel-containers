###############################     Base    #################################################
FROM node:21-alpine3.18 as prod

ARG UID=1000
ARG GID=1000
ARG TZ=America/Chicago #`readlink /etc/localtime | awk -Fzoneinfo/ '{print $2}'` to get your s

RUN apk add -U alpine-conf tzdata \
    && setup-timezone -z ${TZ} \
    && apk del alpine-conf \
    && deluser --remove-home node \
    && addgroup -g ${GID} app \
    && adduser -D -u ${UID} -G app -s /bin/bash app \
    && mkdir -p /home/app/.config \
    && chown app:app /home/app/.config

USER app
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

RUN apk add git\ 
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
    && mkdir -p /etc/sudoers.d && echo 'app ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/app

USER app
RUN git clone https://github.com/tmux-plugins/tpm /home/app/.tmux/plugins/tpm \
    && echo -e "[user]\n	email = jasonmb626@gmail.com\n	name = Jason Brunelle\n[init]\n	defaultBranch = main\n[pull]	rebase = false" >/home/app/.gitconfig \

CMD ["tmux"]

###############################     Base    #################################################
FROM node:21-alpine3.18 as prod

ARG UID=1000
ARG GID=1000

#To get the timezone on your host machine run the below
#readlink /etc/localtime | awk -Fzoneinfo/ '{print $2}'
#ARG TZ=America/Chicago 
ENV GDM_LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

    #&& setup-timezone -z ${TZ} \
RUN apk add -U alpine-conf tzdata \
    && apk del alpine-conf \
    && deluser --remove-home node \
    && addgroup -g ${GID} app \
    && adduser -D -u ${UID} -G app -s /bin/bash app \
    && mkdir -p /home/app/.config \
    && chown app:app /home/app/.config\
    && chmod 777 /tmp

USER app
WORKDIR /app
COPY app/. .

#These (esp the LANG variable) make sure tmux outputs UTF-8. Needed for special chars
COPY requirements.txt /tmp


RUN if [[ -s package.json ]]; then\
        npm install;\
    fi

CMD ["node", "app.js"]

#############################   Development   ################################################
FROM prod as dev

USER root

RUN apk add git\ 
         lua-dev luarocks stylua\
         lazygit openssh\
         py3-pip\
         tmux neovim neovim-doc\
         procps\
         tmux\
         ripgrep\
         alpine-sdk\
         tree-sitter tree-sitter-cli\
         wl-clipboard\
         sudo \
         unzip gzip fd mercurial wget\
    && npm install -g neovim\
    && mkdir -p /etc/sudoers.d && echo 'app ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/app

USER app
RUN python3 -m venv /home/app/.venv \
    && cat <<EOF > /home/app/.bash_profile 
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
EOF

RUN cat <<EOF >/home/app/.bashrc 
source /home/app/.venv/bin/activate
if [[ ! -x /home/app/.local/share/nvim/lazy/nvim-treesitter/parser/markdown.so ]]; then
    if [[ -x /home/app/.config/nvim/auto_install_dependencies.sh ]]; then
        /home/app/.config/nvim/auto_install_dependencies.sh >/dev/null 2>&1
    fi
fi
EOF

COPY requirements-dev.txt /tmp
RUN source /home/app/.venv/bin/activate\
    && pip3 install --upgrade pip \
    && pip3 install -r /tmp/requirements-dev.txt && rm /tmp/requirements-dev.txt\
    && pip3 install pynvim\
    && git clone https://github.com/tmux-plugins/tpm /home/app/.config/tmux/plugins/tpm \
    && git clone https://github.com/jasonmb626/epicvim.git /home/app/.config/nvim

CMD ["tmux"]

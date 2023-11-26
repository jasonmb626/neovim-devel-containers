###############################     prod    #################################################
FROM python:3.9.18-alpine as prod

ARG UID=1000
ARG GID=1000

RUN addgroup -g ${GID} dev \
    && adduser -D -u ${UID} -G dev -s /bin/bash dev \
    && mkdir -p /home/dev/.config \
    && chown dev:dev /home/dev/.config

USER dev
RUN python -m venv /home/dev/.venv \
    && cat <<EOF >> /home/dev/.bashrc 
source /home/dev/.venv/bin/activate
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
EOF

RUN cat <<EOF > /home/dev/.bash_profile 
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
EOF

WORKDIR /app

CMD ["pyton3", "app.py"]

###############################     dev    #################################################
FROM prod as dev

USER root

RUN apk add git\
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
         --update\
    && mkdir -p /etc/sudoers.d && echo 'dev ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/dev \
    && pip3 install pynvim

USER dev
RUN git clone https://github.com/tmux-plugins/tpm /home/dev/.tmux/plugins/tpm \
    && echo -e "[user]\n	email = jasonmb626@gmail.com\n	name = Jason Brunelle\n[init]\n	defaultBranch = main\n[pull]	rebase = false" >/home/dev/.gitconfig 

CMD ["tmux"]

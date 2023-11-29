###############################     prod    #################################################
FROM python:3.9.18-alpine as prod

ARG UID=1000
ARG GID=1000

#To get the timezone on your host machine run the below
#readlink /etc/localtime | awk -Fzoneinfo/ '{print $2}'
ARG TZ=America/Chicago

RUN apk add -U alpine-conf tzdata \
    && setup-timezone -z ${TZ} \
    && apk del alpine-conf \
    && addgroup -g ${GID} app \
    && adduser -D -u ${UID} -G app -s /bin/bash app \
    && mkdir -p /home/app/.config \
    && chown app:app /home/app/.config

USER app
RUN python -m venv /home/app/.venv \
    && cat <<EOF >> /home/app/.bashrc 
source /home/app/.venv/bin/activate
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
EOF

RUN cat <<EOF > /home/app/.bash_profile 
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
         lua-dev luarocks stylua\
         lazygit\
         tmux neovim neovim-doc py3-pynvim\
         #pyright depends on npm -- yuck
         npm\ 
         procps\
         ripgrep\
         alpine-sdk\
         tree-sitter tree-sitter-cli\
         wl-clipboard\
         sudo\
         --update\
    && mkdir -p /etc/sudoers.d && echo 'app ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/app \
    && pip3 install pynvim

USER app
RUN git clone https://github.com/tmux-plugins/tpm /home/app/.config/tmux/plugins/tpm \
    && echo -e "[user]\n	email = jasonmb626@gmail.com\n	name = Jason Brunelle\n[init]\n	defaultBranch = main\n[pull]	rebase = false" >/home/app/.gitconfig 

CMD ["tmux"]

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
EOF

WORKDIR /home/app

COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt && rm requirements.txt\
    && cat <<EOF > /home/app/.bash_profile 
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
         lazygit git-flow openssh\
         mercurial\
         tmux neovim neovim-doc py3-pynvim\
         procps\
         ripgrep\
         alpine-sdk\
         tree-sitter tree-sitter-cli\
         wl-clipboard\
         sudo\
         unzip gzip fd wget\
         --update\
    && mkdir -p /etc/sudoers.d && echo 'app ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/app

WORKDIR /home/app

USER app
COPY requirements-dev.txt requirements-dev.txt
#in the below run pyright once so it installs prebuilt node into virtual environment too
RUN source /home/app/.venv/bin/activate\
    && pip3 install --upgrade pip \
    && pip3 install -r requirements-dev.txt && rm requirements-dev.txt\
    && pyright\
    && git clone https://github.com/tmux-plugins/tpm /home/app/.config/tmux/plugins/tpm \
    && git clone https://github.com/jasonmb626/epicvim.git /home/app/.config/nvim

WORKDIR /app
CMD ["tmux"]

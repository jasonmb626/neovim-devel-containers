###############################     production (base)    #################################################
FROM fedora:39 as prod

ARG UID=1000
ARG GID=1000

ARG NODE_VER=--lts
ARG PY_VER=system

ENV GDM_LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN groupadd -g ${GID} app \
    && useradd -u ${UID} -g ${GID} app \
    && mkdir -p /home/app/.config \ 
    && chown app:app /home/app/.config \
    && chmod 777 /tmp \
    && dnf install -y git

USER app
COPY requirements.txt /tmp
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
export PYENV_ROOT="\$HOME/.pyenv"
[[ -d \$PYENV_ROOT/bin ]] && export PATH="\$PYENV_ROOT/bin:\$PATH"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
source /home/app/.venv/bin/activate
EOF

WORKDIR /home/app
SHELL ["/bin/bash", "-c"]
RUN source /home/app/.venv/bin/activate && pip3 install -r /tmp/requirements.txt && rm /tmp/requirements.txt \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash \
    && source /home/app/.nvm/nvm.sh \
    && git clone https://github.com/tmux-plugins/tpm /home/app/.tmux/plugins/tpm \
    && nvm install ${NODE_VER} \
    && curl https://pyenv.run | bash
RUN source /home/app/.bashrc\
    && CURRENT_PY_VER=$(python3 --version | awk '{print $2}')\
    && if [[ "$PY_VER" != "" && "$PY_VER" != "system" && "$PY_VER" != "$CURRENT_PY_VER" ]]; then\
        pyenv install $PY_VER;\
    fi\
    && echo "pyenv local $PY_VER" >>/home/app/.bashrc
WORKDIR /app
CMD ["python3", "app.py"]
#CMD ["node", "app.js"]

###############################     dev    #################################################
FROM prod as dev

USER root
RUN dnf install -y 'dnf-command(copr)' \
    && dnf copr -y enable atim/lazygit \
    && dnf install -y\
         lazygit\
         openssh wget\
	 luarocks\
         ripgrep\
         tmux\
         neovim \
         python3-pip \
         gcc gcc-c++ patch\
         procps\
         mercurial fd-find\
    && source /home/app/.nvm/nvm.sh && npm install -g neovim\
    && mkdir -p /etc/sudoers.d && echo 'app ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/app
COPY requirements-dev.txt /tmp
USER app
RUN source /home/app/.venv/bin/activate && pip3 install -r /tmp/requirements-dev.txt && rm /tmp/requirements-dev.txt

CMD ["tmux]

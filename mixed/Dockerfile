###############################     Base    #################################################
FROM fedora:39

ARG UID=1000
ARG GID=1000

ENV GDM_LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN groupadd -g ${GID} dev \
    && useradd -u ${UID} -g ${GID} dev \
    && mkdir -p /home/dev/.config \ 
    && chown dev:dev /home/dev/.config \
    && dnf install -y 'dnf-command(copr)' \
    && dnf copr -y enable atim/lazygit \
    && dnf install -y\
         lazygit\
         git\
	 luarocks\
         ripgrep\
         tmux\
         neovim \
         python3-pip \
         patch \
         gcc\
         zlib-devel\
         bzip2\
         bzip2-devel\
         readline-devel\
         sqlite\
         sqlite-devel\
         openssl-devel\
         xz xz-devel\
         libffi-devel\
    && pip3 install pynvim \
    && mkdir -p /etc/sudoers.d && echo 'dev ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/dev

USER dev
RUN python3 -m venv /home/dev/.venv 
RUN <<EOC
    cat <<EOF > /home/dev/.bash_profile 
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
EOF
    cat <<EOF >/home/dev/.bashrc 
export PYENV_ROOT="\$HOME/.pyenv"
[[ -d \$PYENV_ROOT/bin ]] && export PATH="\$PYENV_ROOT/bin:\$PATH"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
source /home/dev/.venv/bin/activate
EOF
EOC

ARG NODE_VER=--lts
ARG PY_VER=system

WORKDIR /home/dev
SHELL ["/bin/bash", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash \
    && source /home/dev/.nvm/nvm.sh \
    && git clone https://github.com/tmux-plugins/tpm /home/dev/.tmux/plugins/tpm \
    && echo -e "[user]\n	email = jasonmb626@gmail.com\n	name = Jason Brunelle\n[init]\n	defaultBranch = main\n[pull]	rebase = false" >/home/dev/.gitconfig \
    && nvm install ${NODE_VER} \
    && curl https://pyenv.run | bash

RUN source /home/dev/.bashrc\
    && CURRENT_PY_VER=$(python3 --version | awk '{print $2}')\
    && if [[ "$PY_VER" != "" && "$PY_VER" != "system" && "$PY_VER" != "$CURRENT_PY_VER" ]]; then\
        pyenv install $PY_VER;\
    fi\
    && echo "pyenv local $PY_VER" >>/home/dev/.bashrc

USER dev
WORKDIR /app
CMD ["tmux"]

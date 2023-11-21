###############################     Base    #################################################
FROM fedora:39

ARG node_ver=--lts
ARG py_ver=""

ENV CHARSET=${CHARSET:-UTF-8}

WORKDIR /app

RUN adduser dev \
    && touch /home/dev/{.bashrc,.bash_profile} \
    && chown dev:dev /home/dev/{.bashrc,.bash_profile} \
    && mkdir -p /home/dev/.ssh \
    && chown dev:dev /home/dev/.ssh \
    && touch /home/dev/.ssh/config \
    && chown -R dev:dev /home/dev/.ssh \
    && touch /home/dev/.gitconfig \
    && chown -R dev:dev /home/dev/.gitconfig \
    && mkdir -p /home/dev/.local/share/nvim \
    && chown -R dev:dev /home/dev/.local/share/nvim \
    && mkdir -p /home/dev/.config/tmux \
    && chown -R dev:dev /home/dev/.config/tmux \
    && dnf install -y 'dnf-command(copr)' \
    && dnf copr -y enable atim/lazygit \
    && dnf install -y\
         git\
         lazygit\
         openssh\
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
    && mkdir -p /etc/sudoers.d \
    && echo 'dev ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/dev \
    && echo -e "Host *\n    StrictHostKeyChecking no" > /home/dev/.ssh/config && chown dev:dev /home/dev/.ssh/config && chmod 400 /home/dev/.ssh/config

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
source /home/dev/.venv/bin/activate
export PYENV_ROOT="\$HOME/.pyenv"
[[ -d \$PYENV_ROOT/bin ]] && export PATH="\$PYENV_ROOT/bin:\$PATH"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
EOF
EOC

SHELL ["/bin/bash", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash \
    && source /home/dev/.nvm/nvm.sh \
    && git clone https://github.com/tmux-plugins/tpm /home/dev/.tmux/plugins/tpm \
    && echo -e "[user]\n	email = jasonmb626@gmail.com\n	name = Jason Brunelle\n[init]\n	defaultBranch = main\n[pull]	rebase = false" >/home/dev/.gitconfig \
    && nvm install --lts \
    && curl https://pyenv.run | bash

CMD ["tmux"]

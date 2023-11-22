###############################     Base    #################################################
FROM python:3.9.18-alpine

WORKDIR /app

RUN adduser -D dev -s /bin/bash \
    && touch /home/dev/.bashrc \
    && chown dev:dev /home/dev/.bashrc \
    && mkdir -p /home/dev/.config/lazygit \
    && touch /home/dev/.config/lazygit/config.yml \
    && chown -R dev:dev /home/dev/.config/lazygit

RUN cat <<EOF >> /home/dev/.bashrc 
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

USER dev
RUN python -m venv /home/dev/.venv
RUN pip3 install pynvim

USER root

RUN mkdir -p /home/dev/.ssh && chown dev:dev /home/dev/.ssh && touch /home/dev/.ssh/config && chown -R dev:dev /home/dev/.ssh && touch /home/dev/.gitconfig && chown -R dev:dev /home/dev/.gitconfig && mkdir -p /home/dev/.local/share/nvim && chown -R dev:dev /home/dev/.local/share/nvim && mkdir -p /home/dev/.config/tmux && chown -R dev:dev /home/dev/.config/tmux

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
         --update && \
    echo 'dev ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/dev && \
    echo -e "Host *\n    StrictHostKeyChecking no" > /home/dev/.ssh/config && chown dev:dev /home/dev/.ssh/config && chmod 400 /home/dev/.ssh/config && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

USER dev
RUN git clone https://github.com/tmux-plugins/tpm /home/dev/.tmux/plugins/tpm && echo -e "[user]\n	email = jasonmb626@gmail.com\n	name = Jason Brunelle\n[init]\n	defaultBranch = main\n[pull]	rebase = false" >/home/dev/.gitconfig

CMD ["tmux"]

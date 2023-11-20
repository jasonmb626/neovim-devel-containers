###############################     Base    #################################################
FROM python:3.9.18-alpine

WORKDIR /app

RUN <<EOC
    adduser -D dev -s /bin/bash
    touch /home/dev/{.bashrc,.bash_profile}
    chown dev:dev /home/dev/{.bashrc,.bash_profile}
    mkdir -p /home/dev/.ssh
    chown dev:dev /home/dev/.ssh
    touch /home/dev/.ssh/config
    chown -R dev:dev /home/dev/.ssh
    touch /home/dev/.gitconfig
    chown -R dev:dev /home/dev/.gitconfig
    mkdir -p /home/dev/.local/share/nvim
    chown -R dev:dev /home/dev/.local/share/nvim
    mkdir -p /home/dev/.config/tmux
    chown -R dev:dev /home/dev/.config/tmux
    apk add git\
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
         --update
    mkdir -p /etc/sudoers.d
    echo 'dev ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/dev
    echo -e "Host *\n    StrictHostKeyChecking no" > /home/dev/.ssh/config && chown dev:dev /home/dev/.ssh/config && chmod 400 /home/dev/.ssh/config
EOC

USER dev
RUN <<EOC
    python -m venv /home/dev/.venv
    pip3 install pynvim
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
EOF
EOC

SHELL ["/bin/bash", "-c"]
RUN <<EOC
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
    echo "export NVM_NODEJS_ORG_MIRROR=https://unofficial-builds.nodejs.org/download/release" >> /home/dev/.bashrc
    echo "nvm_get_arch() { nvm_echo \"x64-musl\"; }" >> /home/dev/.bashrc
    source /home/dev/.nvm/nvm.sh
    git clone https://github.com/tmux-plugins/tpm /home/dev/.tmux/plugins/tpm && echo -e "[user]\n	email = jasonmb626@gmail.com\n	name = Jason Brunelle\n[init]\n	defaultBranch = main\n[pull]	rebase = false" >/home/dev/.gitconfig
    nvm install --lts
EOC

CMD ["tmux"]

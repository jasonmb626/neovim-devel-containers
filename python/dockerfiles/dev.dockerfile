###############################     Base    #################################################
FROM python:3.9.18-alpine

ENV ENV=/home/dev/.ashrc

WORKDIR /app

RUN adduser -D dev && echo "source /home/dev/.venv/bin/activate" >> /home/dev/.ashrc && chown dev:dev /home/dev/.ashrc

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
    echo -e "Host *\n    StrictHostKeyChecking no" > /home/dev/.ssh/config && chown dev:dev /home/dev/.ssh/config && chmod 400 /home/dev/.ssh/config

USER dev
RUN git clone https://github.com/tmux-plugins/tpm /home/dev/.tmux/plugins/tpm && echo -e "[user]\n	email = jasonmb626@gmail.com\n	name = Jason Brunelle\n[init]\n	defaultBranch = main\n[pull]	rebase = false" >/home/dev/.gitconfig

CMD ["tmux"]

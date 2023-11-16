FROM python:3.9.18-alpine

ARG RUN_ENV

ENV ENV=/home/app/.ashrc

RUN apk add git --update

RUN adduser -D app

RUN mkdir -p /home/app/.ssh && chown app:app /home/app/.ssh

USER app
RUN python -m venv /home/app/.venv

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

USER root
RUN touch /home/app/.ssh/config; chown -R app:app /home/app/.ssh; chmod 400 /home/app/.ssh/config; touch /home/app/.gitconfig; chown -R app:app /home/app/.gitconfig; rm /tmp/requirements.txt;

COPY requirements-dev.txt /tmp/requirements-dev.txt
RUN if [ "$RUN_ENV" == "DEV" ]; then \
    apk add stylua\
             npm\
             openssh\
             lua-app luarocks\
             lazygit\
             tmux neovim neovim-doc py3-pynvim\
             procps\
             ripgrep\
             alpine-sdk\
             tree-sitter tree-sitter-cli\
             fd\ 
             wl-clipboard\
             sudo\
             --update;\
    echo -e "Host *\n    StrictHostKeyChecking no" > /home/app/.ssh/config;\
    echo 'app ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/app;\
fi

USER app
RUN if [ "$RUN_ENV" == "DEV" ]; then \
    pip3 install -r /tmp/requirements-dev.txt; \
    rm /tmp/requirements-dev.txt;\
    mkdir -p /home/app/.local/share/nvim; mkdir -p /home/app/.config/tmux;\
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm;\
    echo -e "[user]\n	email = jasonmb626@gmail.com\n	name = Jason Brunelle\n[init]\n	defaultBranch = main\n[pull]	rebase = false" >/home/app/.gitconfig;\
else\
    rm -fr /home/app/.ssh;\
fi

RUN echo "source /home/app/.venv/bin/activate" >> /home/app/.ashrc
WORKDIR /app

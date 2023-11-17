###############################     Base    #################################################
FROM python:3.9.18-alpine as prod

ENV ENV=/home/app/.ashrc

WORKDIR /app
COPY app/. .

RUN adduser -D app && echo "source /home/app/.venv/bin/activate" >> /home/app/.ashrc

USER app
RUN python -m venv /home/app/.venv
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

USER root
RUN rm /tmp/requirements.txt 2>/dev/null

CMD ["python", "app.py"]

#############################   Development   ################################################
FROM prod as dev

RUN mkdir -p /home/app/.ssh && chown app:app /home/app/.ssh && touch /home/app/.ssh/config && chown -R app:app /home/app/.ssh && touch /home/app/.gitconfig && chown -R app:app /home/app/.gitconfig && mkdir -p /home/app/.local/share/nvim && chown -R app:app /home/app/.local/share/nvim && mkdir -p /home/app/.config/tmux && chown -R app:app /home/app/.config/tmux

COPY requirements-dev.txt /tmp/requirements-dev.txt
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
    echo 'app ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/app

USER app
RUN echo -e "Host *\n    StrictHostKeyChecking no" > /home/app/.ssh/config && chmod 400 /home/app/.ssh/config &&\
    pip3 install -r /tmp/requirements-dev.txt && git clone https://github.com/tmux-plugins/tpm /home/app/.tmux/plugins/tpm &&\
    echo -e "[user]\n	email = jasonmb626@gmail.com\n	name = Jason Brunelle\n[init]\n	defaultBranch = main\n[pull]	rebase = false" >/home/app/.gitconfig

USER root
RUN rm /tmp/requirements-dev.txt 2>/dev/null
CMD ["tmux"]

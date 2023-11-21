###############################     Base    #################################################
FROM node:21-alpine3.18 as prod

WORKDIR /app
COPY app/. .

#RUN if [[ -s package.json ]]; then\
#        npm install;\
#    fi

CMD ["node", "app.js"]

#############################   Development   ################################################
FROM prod as dev

RUN mkdir -p /home/node/.ssh && chown node:node /home/node/.ssh && touch /home/node/.ssh/config && chown -R node:node /home/node/.ssh && touch /home/node/.gitconfig && chown -R node:node /home/node/.gitconfig && mkdir -p /home/node/.local/share/nvim && chown -R node:node /home/node/.local/share/nvim && mkdir -p /home/node/.config/tmux && chown -R node:node /home/node/.config/tmux

RUN cat /etc/apk/repositories | sed 's/3.17/3.18/g' >/etc/apk/repositories && \
    apk update && apk upgrade && apk add git\ 
         libncursesw\
         libpanelw\
         lua-dev luarocks\
         lazygit\
         tmux neovim neovim-doc\
         procps\
         ripgrep\
         alpine-sdk\
         tree-sitter tree-sitter-cli\
         fd\ 
         wl-clipboard\
         sudo &&\
    mkdir -p /etc/sudoers.d && echo 'node ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/node
RUN sudo apk add ada-libs \
       bash \
       c-ares \
       gdbm \
       icu-data-en \
       icu-libs \
       isl26 \
       keyutils-libs \
       krb5-conf \
       krb5-libs \
       libbz2 \
       libcom_err \
       libedit \
       libidn2 \
       libnsl \
       libproc2 \
       libtirpc \
       libtirpc-conf \
       libunistring \
       libuuid \
       libverto \
       mpdecimal \
       nodejs-current \
       npm \
       openssh \
       openssh-client-common \
       openssh-client-default \
       openssh-keygen \
       openssh-server \
       openssh-server-common \
       openssh-sftp-server \
       procps-ng \
       py3-greenlet \
       py3-greenlet-pyc \
       py3-msgpack \
       py3-msgpack-pyc \
       py3-pynvim \
       py3-pynvim-pyc \
       pyc \
       python3 \
       python3-pyc \
       python3-pycache-pyc0 \
       readline \
       sqlite-libs \
       tzdata \
       xz-libs \
       zstd-libs

RUN echo -e "Host *\n    StrictHostKeyChecking no" > /home/node/.ssh/config && chmod 400 /home/node/.ssh/config

CMD ["ash"]

###############################     prod    #################################################
FROM node:21-alpine3.17 as prod

ARG ssh_pub_key

WORKDIR /app
COPY app/. .

RUN if [[ -s package.json ]]; then\
        npm install;\
    fi

cmd ["node", "app.js"]

###############################     dev    #################################################
FROM prod as dev

ARG ssh_pub_key

USER root
RUN cat /etc/shadow | grep -v "^node:" > /etc/shadow \
    && echo "node::19677:0:99999:7:::" >> /etc/shadow
RUN mkdir -p /home/node/.ssh \
    && chmod 0700 /home/node/.ssh \
    && echo "$ssh_pub_key" > /home/node/.ssh/authorized_keys \
    && chown -R node:node /home/node/ && chmod 600 /home/node/.ssh/authorized_keys \
    && apk --nocache --update add openrc openssh neovim bash \
    && echo -e "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && mkdir -p /run/openrc \
    && touch /run/openrc/softlevel 

RUN touch /home/node/entrypoint.sh && chmod +x /home/node/entrypoint.sh && cat >/home/node/entrypoint.sh <<EOF
#!/bin/sh
ssh-keygen -A
exec /usr/sbin/sshd -D -e "\$@"
EOF
ENTRYPOINT ["/home/node/entrypoint.sh"]
#CMD ["tail", "-f", "/dev/null"]
EXPOSE 22

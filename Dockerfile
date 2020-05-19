FROM adoptopenjdk/openjdk8

ENV LANG C.UTF-8

# Jenkins ssh user

COPY ssh.sh /ssh.sh

ENV JUSER jenkins
ENV JENKINS_HOME /srv/jenkins

RUN mkdir -p $JENKINS_HOME && addgroup $JUSER && \
    adduser -S -G $JUSER -H -h $JENKINS_HOME -D -s /bin/bash $JUSER && \
    install -d -o $JUSER -g $JUSER $JENKINS_HOME && \
    install -d -m 700 -o $JUSER -g $JUSER $JENKINS_HOME/.ssh && \
    chown -R $JUSER:$JUSER $JENKINS_HOME/.ssh/ && \
    touch $JENKINS_HOME/.ssh/authorized_keys && \
    chmod 600 $JENKINS_HOME/.ssh/authorized_keys && \
    passwd -u $JUSER
#    mv $JENKINS_HOME/.ssh /jenkins-ssh

# SSH server

RUN apk add --no-cache openssh bash git && \
    mkdir -p ~root/.ssh /etc/authorized_keys && chmod 700 ~root/.ssh/ && \
    sed -i -e 's@^AuthorizedKeysFile.*@@g' /etc/ssh/sshd_config  && \
    echo -e "AuthorizedKeysFile\t%h/.ssh/authorized_keys /etc/authorized_keys/%u" >> /etc/ssh/sshd_config && \
    echo -e "Port 22\n" >> /etc/ssh/sshd_config && \
    cp -a /etc/ssh /etc/ssh.cache && \
    cat /etc/ssh/sshd_config

EXPOSE 22


ENTRYPOINT ["/ssh.sh"]
CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]

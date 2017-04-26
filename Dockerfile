FROM docker/compose:1.12.0

ENV LANG C.UTF-8

# Java runtime

RUN { \
                echo '#!/bin/sh'; \
                echo 'set -e'; \
                echo; \
                echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
        } > /usr/local/bin/docker-java-home \
        && chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.7-openjdk/jre
ENV PATH $PATH:/usr/lib/jvm/java-1.7-openjdk/jre/bin:/usr/lib/jvm/java-1.7-openjdk/bin

ENV JAVA_VERSION 7u121
ENV JAVA_ALPINE_VERSION 7.121.2.6.8-r0
RUN set -x \
        && apk add --no-cache \
                openjdk7-jre-base="$JAVA_ALPINE_VERSION" \
        && [ "$JAVA_HOME" = "$(docker-java-home)" ]

# Jenkins ssh user

ADD jenkins.pub /
COPY ssh.sh /ssh.sh

RUN addgroup jenkins-slave && \
    adduser -S -G jenkins-slave -H -h /jenkins-slave -D -s /bin/bash jenkins-slave && \
    install -d -o jenkins-slave -g jenkins-slave /jenkins-slave && \
    install -d -m 700 -o jenkins-slave -g jenkins-slave /jenkins-slave/.ssh && \
    cat /jenkins.pub >> /jenkins-slave/.ssh/authorized_keys && \
    chown -R jenkins-slave:jenkins-slave /jenkins-slave/.ssh/ && \
    chmod 600 /jenkins-slave/.ssh/authorized_keys && \
    passwd -u jenkins-slave

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

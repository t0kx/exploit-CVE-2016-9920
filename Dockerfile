# Yeah I know... not the perfect one
# but you know, never change a running
# system...
FROM debian:jessie

MAINTAINER t0kx <t0kx@protonmail.ch>

# install debian stuff
RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    wget apache2 php5 php5-sqlite sqlite3 git golang sendmail-bin \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# "configure" smtpd and imapd
RUN echo "127.0.1.1 myhostname myhostname" >> /etc/hosts && \
    GOPATH=/tmp/ go get github.com/jordwest/imap-server/demo && \
    GOPATH=/tmp/ go build github.com/jordwest/imap-server/demo && \
    yes Y | sendmailconfig

# configure vuln application
RUN wget https://github.com/roundcube/roundcubemail/releases/download/1.2.2/roundcubemail-1.2.2-complete.tar.gz && \
    tar xfz roundcubemail-1.2.2-complete.tar.gz -C /var/www/html/ && \
    mv /var/www/html/roundcubemail-1.2.2/ /var/www/html/roundcube/ && \
    sqlite3 /var/www/html/roundcube/sqlite.db < /var/www/html/roundcube/SQL/sqlite.initial.sql && \
    sed -i "s/config\['default_port'\] = 143;/config\['default_port'\] = 10143;/g" \
        /var/www/html/roundcube/config/defaults.inc.php

RUN chmod 777 -R /var/www/html/

COPY config.inc.php /var/www/html/roundcube/config/

EXPOSE 80

COPY main.sh /
ENTRYPOINT ["/main.sh"]
CMD ["default"]

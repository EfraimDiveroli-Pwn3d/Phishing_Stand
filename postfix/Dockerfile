FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    postfix \
    opendkim \
    opendkim-tools \
    gettext-base \
    supervisor \
    rsyslog \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
COPY templates/header_checks /etc/postfix/header_checks
COPY templates/master.cf /etc/postfix/master.cf
COPY templates/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY templates/main.cf.template /templates/main.cf.template
COPY templates/opendkim.conf.template /templates/opendkim.conf.template
COPY templates/KeyTable.template /templates/KeyTable.template
COPY templates/SigningTable.template /templates/SigningTable.template
COPY templates/TrustedHosts /etc/opendkim/TrustedHosts

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
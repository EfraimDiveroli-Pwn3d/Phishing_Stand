FROM nginx:alpine

RUN apk add --no-cache gettext

COPY templates/nginx.conf.template /etc/nginx/nginx.conf.template
COPY templates/mta-sts.txt.template /var/www/html/mta-sts.txt.template
COPY entrypoint.sh /docker-entrypoint.d/01-template.sh

RUN chmod +x /docker-entrypoint.d/01-template.sh
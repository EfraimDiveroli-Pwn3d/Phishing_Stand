#!/bin/sh

set -e

echo "[*] Шаблонизация nginx.conf с использованием переменных окружения..."
envsubst '${TRACK_DOMAIN} ${EVIL_DOMAIN} ${BASE_DOMAIN} ${EVILGINX_BACKEND} ${GOPHISH_BACKEND}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
echo "[+] nginx.conf успешно сгенерирован для доменов ${TRACK_DOMAIN}, ${EVIL_DOMAIN} и ${BASE_DOMAIN}."

echo "[*] Шаблонизация mta-sts.txt с использованием переменных окружения..."
envsubst '${MX_DOMAIN}' < /var/www/html/mta-sts.txt.template > /var/www/html/mta-sts.txt
echo "[+] mta-sts.txt успешно сгенерирован для домена ${MX_DOMAIN}."

exec "$@"
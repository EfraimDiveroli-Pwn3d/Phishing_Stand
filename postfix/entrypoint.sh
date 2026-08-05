#!/bin/sh

set -e

mkdir -p /etc/opendkim/keys

echo "[*] Шаблонизация main.cf с использованием переменных окружения..."
envsubst '${HOSTNAME} ${ALLOWED_SENDER_DOMAINS}' < /templates/main.cf.template > /etc/postfix/main.cf
echo "[+] main.cf успешно сгенерирован для домена ${ALLOWED_SENDER_DOMAINS}."

echo "[*] Шаблонизация opendkim.conf с использованием переменных окружения..."
envsubst '${ALLOWED_SENDER_DOMAINS}' < /templates/opendkim.conf.template > /etc/opendkim.conf
echo "[+] opendkim.conf успешно сгенерирован для домена ${ALLOWED_SENDER_DOMAINS}."

echo "[*] Шаблонизация KeyTable с использованием переменных окружения..."
envsubst '${ALLOWED_SENDER_DOMAINS}' < /templates/KeyTable.template > /etc/opendkim/KeyTable
echo "[+] KeyTable успешно сгенерирован для домена ${ALLOWED_SENDER_DOMAINS}."

echo "[*] Шаблонизация SigningTable с использованием переменных окружения..."
envsubst '${ALLOWED_SENDER_DOMAINS}' < /templates/SigningTable.template > /etc/opendkim/SigningTable
echo "[+] SigningTable успешно сгенерирован для домена ${ALLOWED_SENDER_DOMAINS}."


KEYFILE="/etc/opendkim/keys/${ALLOWED_SENDER_DOMAINS}.private"

for keyfile in /etc/opendkim/keys/*.private; do
    if [ -f "$keyfile" ]; then
        chown opendkim:opendkim "$keyfile"
        chmod 600 "$keyfile"
    fi
done

if [ ! -f "$KEYFILE" ]; then

    echo "[*] Генерация DKIM-ключей..."

    cd /tmp

    opendkim-genkey \
        -s mail \
        -d "${ALLOWED_SENDER_DOMAINS}"

    mv mail.private "$KEYFILE"
    mv mail.txt "/etc/opendkim/keys/${ALLOWED_SENDER_DOMAINS}.txt"

    chown opendkim:opendkim "$KEYFILE"

    echo "[+] Ключи успешно сгенерированы. "
    echo "[+] Добавьте DNS-запись mail._domainkey:"
    cat "/etc/opendkim/keys/${ALLOWED_SENDER_DOMAINS}.txt"
    echo ""
fi

exec /usr/bin/supervisord -n
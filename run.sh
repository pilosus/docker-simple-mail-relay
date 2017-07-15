#!/usr/bin/env ash

# Configure Postfix
echo "smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)" >> /etc/postfix/main.cf
echo "biff = no" >> /etc/postfix/main.cf
echo "append_dot_mydomain = no" >> /etc/postfix/main.cf

echo "myhostname=${CONTAINER_HOSTNAME:-example.com}" >> /etc/postfix/main.cf
echo "mydomain=${CONTAINER_DOMAIN:-example.com}" >> /etc/postfix/main.cf
echo 'mydestination=$myhostname'  >> /etc/postfix/main.cf
echo 'myorigin=$mydomain'  >> /etc/postfix/main.cf
echo "relayhost = [${CONTAINER_RELAY_HOSTNAME:-relay.example.com}]:${CONTAINER_RELAY_PORT:-25}" >> /etc/postfix/main.cf
echo "mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 ${CONTAINER_ALLOWED_NETWORKS:-192.168.0.0/16 172.16.0.0/12 10.0.0.0/8}" >> /etc/postfix/main.cf
echo "smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination" >> /etc/postfix/main.cf

echo "mailbox_size_limit = 0" >> /etc/postfix/main.cf
echo "recipient_delimiter = +" >> /etc/postfix/main.cf
echo "inet_interfaces = all" >> /etc/postfix/main.cf

echo "smtp_use_tls = no" >> /etc/postfix/main.cf
echo "smtp_sasl_auth_enable = no" >> /etc/postfix/main.cf

# Launch
rm -f /var/spool/postfix/pid/*.pid
exec /usr/bin/supervisord -n -c /etc/supervisord.conf

FROM alpine:edge
LABEL maintainer "Vitaly Samigullin <vrs@pilosus.org>"

# Alpine Linux has no init system, the service running has pid 1
# So we use supervisor to start several processes at once
RUN echo ' ---> Setting up packages' \
    && apk update \
    && apk add --no-cache postfix rsyslog supervisor \
    && (rm "/tmp/"* 2>/dev/null || true) \
    && (rm -rf /var/cache/apk/* 2>/dev/null || true)

# Configure rsyslog
COPY rsyslog.conf /etc/rsyslog.conf

# Configure supervisord
COPY daemonize.sh /usr/local/bin/
COPY supervisor.ini /etc/supervisor.d/
RUN chmod +x /usr/local/bin/daemonize.sh

# Configure runner script
COPY run.sh /root/
RUN chmod +x /root/run.sh

# Port
EXPOSE 25

# Entry point
CMD ["/root/run.sh"]

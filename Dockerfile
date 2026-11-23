# Kafka UI (kafbat/kafka-ui) for Railway.
# Pinned by version and digest; bump both together and add a CHANGELOG.md entry.
FROM ghcr.io/kafbat/kafka-ui:v1.5.1@sha256:c0585fdfed6a9b8adedc3b0965113d4a84f292d61e58a2c7dcc603394defb7d1

# The start script runs as root only to fix the volume's ownership, then drops to the
# image's own unprivileged user (kafkaui) before it starts the app.
USER root
COPY --chmod=755 start.sh /usr/local/bin/railway-start.sh

# Safe defaults baked in: the console never starts without a login.
ENV AUTH_TYPE=LOGIN_FORM \
    DYNAMIC_CONFIG_ENABLED=true \
    DYNAMIC_CONFIG_PATH=/etc/kafkaui/dynamic_config.yaml \
    CONFIG_RELATED_UPLOADS_DIR=/etc/kafkaui/uploads

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/railway-start.sh"]

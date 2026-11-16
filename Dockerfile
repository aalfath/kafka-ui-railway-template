# Kafka UI (kafbat/kafka-ui) for Railway.
# Pinned by version and digest; bump both together and add a CHANGELOG.md entry.
FROM ghcr.io/kafbat/kafka-ui:v1.5.0@sha256:7cda86a33344160309fdb65146332e4da65db81a945614f2fe32e210803f6fd1

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

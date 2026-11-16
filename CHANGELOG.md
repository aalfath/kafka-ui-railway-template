# Changelog

## 1.5.0 (2026-11-16)

First release of the template.

- Kafka UI (kafbat) v1.5.0, `ghcr.io/kafbat/kafka-ui:v1.5.0@sha256:7cda86a33344160309fdb65146332e4da65db81a945614f2fe32e210803f6fd1`.
- Form login required (generated password); the start script refuses to start without it.
- One-variable cluster setup (`KAFKA_BOOTSTRAP_SERVERS`), clusters editable in the UI and kept on the `/etc/kafkaui` volume.

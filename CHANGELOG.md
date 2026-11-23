# Changelog

## 1.5.1 (2026-11-23)

- Breaking change upstream, only if you set up OAuth2 **resource server** mode yourself: RBAC now also applies to bearer-token requests. The template's default login form (`AUTH_TYPE=LOGIN_FORM`) is not affected.
- Security release: hardened RBAC (GHSA-g5jv-4pv5-fwjq) and config validation (GHSA-fm4j-84h9-xw5v, GHSA-cc2g-3hxq-q686), and a new Java base image for CVE-2026-114938. No new variables. See the [v1.5.1 release notes](https://github.com/kafbat/kafka-ui/releases/tag/v1.5.1).
- Kafka UI v1.5.0 → **v1.5.1** (`ghcr.io/kafbat/kafka-ui:v1.5.1@sha256:c0585fdfed6a9b8adedc3b0965113d4a84f292d61e58a2c7dcc603394defb7d1`).
- Tested on Railway before merging: the published template was deployed, data was written, the service was switched to this version, and the data and login were still there.

## 1.5.0-1 (2026-11-16)

No breaking changes. Documentation only: nothing in the image or start script changed.

- README: Deploy on Railway button for the published template (`kafka-ui-1`).
- README: the generated password has 32 characters, not 24.

## 1.5.0 (2026-11-16)

First release of the template.

- Kafka UI (kafbat) v1.5.0, `ghcr.io/kafbat/kafka-ui:v1.5.0@sha256:7cda86a33344160309fdb65146332e4da65db81a945614f2fe32e210803f6fd1`.
- Form login required (generated password); the start script refuses to start without it.
- One-variable cluster setup (`KAFKA_BOOTSTRAP_SERVERS`), clusters editable in the UI and kept on the `/etc/kafkaui` volume.

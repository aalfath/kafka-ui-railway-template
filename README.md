[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/kafka-ui-1?utm_medium=integration&utm_source=button&utm_campaign=kafka-ui)

# Kafka UI on Railway

[Kafka UI](https://github.com/kafbat/kafka-ui) (kafbat) 1.5.1 for Railway: a web console to browse topics, messages, consumer groups, brokers, schemas and connectors of an Apache Kafka or Redpanda cluster. It is meant as an add-on for a Kafka or Redpanda service that already runs in your Railway project, and talks to it over the private network.

## What the template deploys

One service, **Kafka UI**, built from this repository:

- **Image:** `ghcr.io/kafbat/kafka-ui:v1.5.1@sha256:c0585fdfed6a9b8adedc3b0965113d4a84f292d61e58a2c7dcc603394defb7d1`, wrapped by a small start script (`start.sh`).
- **Login:** form login is always on. The start script refuses to start with no password, a password shorter than 12 characters, or `AUTH_TYPE=DISABLED`.
- **Volume** at `/etc/kafkaui`: clusters you add or edit in the UI (`dynamic_config.yaml`) and uploaded files (truststores, keystores). They survive redeploys.
- **Health check** on `/actuator/health` (no login needed).
- The app runs as the image's unprivileged `kafkaui` user. The start script runs as root only to give that user the volume.

## Variables

| Variable | Default | What it does |
|---|---|---|
| `KAFKA_BOOTSTRAP_SERVERS` | empty (optional) | Bootstrap address of your cluster, for example `${{Kafka.RAILWAY_PRIVATE_DOMAIN}}:9092`. Leave it empty to add clusters in the UI |
| `SPRING_SECURITY_USER_NAME` | `admin` | Login user |
| `SPRING_SECURITY_USER_PASSWORD` | generated (32 characters) | Login password. Find it in the service's Variables tab |
| `PORT` | `8080` | Port the web UI listens on |

Optional settings (add them as variables on the service):

- `KAFKA_CLUSTER_NAME` (default `kafka`): the cluster's name in the UI.
- `KAFKA_SCHEMA_REGISTRY_URL`: for example `http://${{redpanda.RAILWAY_PRIVATE_DOMAIN}}:8081`.
- `JAVA_OPTS` (default `-Xms64m -Xmx512m -XX:+UseSerialGC`).
- Any upstream setting, such as `KAFKA_CLUSTERS_0_PROPERTIES_SECURITY_PROTOCOL=SASL_PLAINTEXT` for a SASL cluster, `KAFKA_CLUSTERS_0_READONLY=true`, or OAuth2/LDAP login. See the [Kafka UI configuration docs](https://ui.docs.kafbat.io/configuration/misc-configuration-properties).

## Connecting it to your cluster

Deploy the template into the same Railway project and environment as your broker (on the project canvas: **Create → Template → Kafka UI**), so it can use the private network. Then set `KAFKA_BOOTSTRAP_SERVERS` to the broker's private address:

- Our [Apache Kafka](https://railway.com/deploy/apache-kafka-1) template: `${{Kafka.KAFKA_PRIVATE_BOOTSTRAP}}`
- Any broker service listening on 9092: `${{<service name>.RAILWAY_PRIVATE_DOMAIN}}:9092`
- Redpanda: `${{redpanda.RAILWAY_PRIVATE_DOMAIN}}:9092`, and the schema registry on port 8081

The broker must advertise its private address (`<service>.railway.internal:9092`) on that listener, or the UI connects and then loses the brokers.

Clusters saved in the UI (Dashboard → Configure new cluster) are stored on the volume and take precedence over the variables. To go back to the variables, delete `dynamic_config.yaml` in the UI's config page or on the volume.

## Updates

This template builds from this repository. When the pinned Kafka UI version changes here, Railway shows deployers an "update available" notice and they choose when to apply it. Read `CHANGELOG.md` before you apply an update.

## Local test

```sh
docker build -t kafka-ui-railway .
docker run --rm -p 8080:8080 -e SPRING_SECURITY_USER_NAME=admin \
  -e SPRING_SECURITY_USER_PASSWORD=change-me-please \
  -e KAFKA_BOOTSTRAP_SERVERS=host.docker.internal:9092 kafka-ui-railway
```

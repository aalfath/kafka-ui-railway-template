#!/bin/sh
# Start script for the Kafka UI Railway template.
set -eu

DATA_DIR=/etc/kafkaui            # the Railway volume: UI-edited config and uploaded files
APP_USER=kafkaui

# --- Login: never start an unprotected console --------------------------------------
case "${AUTH_TYPE:-LOGIN_FORM}" in
  LOGIN_FORM)
    pw="${SPRING_SECURITY_USER_PASSWORD:-}"
    if [ -z "${SPRING_SECURITY_USER_NAME:-}" ] || [ "${#pw}" -lt 12 ]; then
      echo "ERROR: set SPRING_SECURITY_USER_NAME and SPRING_SECURITY_USER_PASSWORD (12+ characters). Refusing to start Kafka UI without a login." >&2
      exit 1
    fi ;;
  DISABLED|"")
    echo "ERROR: AUTH_TYPE=${AUTH_TYPE:-} would expose Kafka UI without a login. Use LOGIN_FORM (default), OAUTH2 or LDAP." >&2
    exit 1 ;;
  *) : ;;  # OAUTH2 / LDAP: configured by the deployer, see the kafbat docs
esac
export AUTH_TYPE="${AUTH_TYPE:-LOGIN_FORM}"

# --- Port -----------------------------------------------------------------------------
export SERVER_PORT="${PORT:-8080}"

# --- Cluster from a single variable ---------------------------------------------------
# KAFKA_BOOTSTRAP_SERVERS=kafka.railway.internal:9092 becomes cluster 0. Leave it empty to
# add clusters in the UI instead. Anything set as KAFKA_CLUSTERS_0_* directly still works.
if [ -n "${KAFKA_BOOTSTRAP_SERVERS:-}" ]; then
  export KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS="${KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS:-$KAFKA_BOOTSTRAP_SERVERS}"
  export KAFKA_CLUSTERS_0_NAME="${KAFKA_CLUSTERS_0_NAME:-${KAFKA_CLUSTER_NAME:-kafka}}"
  if [ -n "${KAFKA_SCHEMA_REGISTRY_URL:-}" ]; then
    export KAFKA_CLUSTERS_0_SCHEMAREGISTRY="${KAFKA_CLUSTERS_0_SCHEMAREGISTRY:-$KAFKA_SCHEMA_REGISTRY_URL}"
  fi
  echo "===> Cluster '${KAFKA_CLUSTERS_0_NAME}' at ${KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS}"
else
  echo "===> KAFKA_BOOTSTRAP_SERVERS is empty: add a cluster in the UI (Dashboard > Configure new cluster)"
fi
if [ -s "${DYNAMIC_CONFIG_PATH}" ]; then
  echo "===> Using the cluster settings saved from the UI in ${DYNAMIC_CONFIG_PATH} (they take precedence over variables)"
fi

# --- JVM: modest heap by default, override with JAVA_OPTS ------------------------------
export JAVA_OPTS="${JAVA_OPTS:--Xms64m -Xmx512m -XX:+UseSerialGC}"

# --- Volume ownership, then drop privileges ---------------------------------------------
mkdir -p "$DATA_DIR" "${CONFIG_RELATED_UPLOADS_DIR}"
if [ "$(id -u)" = "0" ]; then
  chown -R "$APP_USER" "$DATA_DIR"
  exec su -s /bin/sh "$APP_USER" -c 'cd / && exec java --add-opens java.rmi/javax.rmi.ssl=ALL-UNNAMED $JAVA_OPTS -jar /api.jar'
fi
cd /
exec java --add-opens java.rmi/javax.rmi.ssl=ALL-UNNAMED $JAVA_OPTS -jar /api.jar

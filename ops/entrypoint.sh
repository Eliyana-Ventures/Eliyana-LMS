#!/usr/bin/env bash
set -euo pipefail

# Re-exec as frappe if started as root
if [ "$(id -u)" = "0" ]; then
  exec su -s /bin/bash -c "$0" frappe
fi

BENCH_DIR="/home/frappe/frappe-bench"
SITES_DIR="$BENCH_DIR/sites"
SITE_DIR="$SITES_DIR/${SITE_NAME}"
SITE_CONFIG="$SITE_DIR/site_config.json"

cd "$BENCH_DIR"

mkdir -p "$SITE_DIR"

# --- 1) Construct site_config.json deterministically ---
# Priority: SITE_CONFIG_JSON_BASE64 > build from env vars
if [ -n "${SITE_CONFIG_JSON_BASE64:-}" ]; then
  echo "$SITE_CONFIG_JSON_BASE64" | base64 -d > "$SITE_CONFIG"
else
  : "${DB_HOST:?Missing DB_HOST}"
  : "${DB_PORT:?Missing DB_PORT}"
  : "${DB_NAME:?Missing DB_NAME}"
  : "${DB_USER:?Missing DB_USER}"
  : "${DB_PASSWORD:?Missing DB_PASSWORD}"
  : "${ENCRYPTION_KEY:?Missing ENCRYPTION_KEY (32-byte random key recommended)}"

  cat > "$SITE_CONFIG" <<EOF
{
  "db_host": "${DB_HOST}",
  "db_port": "${DB_PORT}",
  "db_name": "${DB_NAME}",
  "db_password": "${DB_PASSWORD}",
  "db_username": "${DB_USER}",
  "encryption_key": "${ENCRYPTION_KEY}"
}
EOF

  # S3 / Spaces (optional, recommended)
  if [ -n "${S3_BUCKET:-}" ] && [ -n "${AWS_ACCESS_KEY_ID:-}" ] && [ -n "${AWS_SECRET_ACCESS_KEY:-}" ]; then
    python3 - <<PY
import json, os
p="${SITE_CONFIG}"
cfg=json.load(open(p))
cfg["use_s3"]=True
cfg["s3_bucket"]=os.environ["S3_BUCKET"]
if os.environ.get("S3_ENDPOINT"): cfg["s3_endpoint"]=os.environ["S3_ENDPOINT"]
json.dump(cfg, open(p,"w"))
PY
  fi
fi

# --- 2) Configure Redis/Valkey roles ---
# Prefer discrete role URLs; else REDIS_URL with db indices (e.g., /1, /2, /3)
if [ -n "${REDIS_CACHE:-}" ];     then bench set-config -g redis_cache    "${REDIS_CACHE}";    fi
if [ -n "${REDIS_QUEUE:-}" ];     then bench set-config -g redis_queue    "${REDIS_QUEUE}";    fi
if [ -n "${REDIS_SOCKETIO:-}" ];  then bench set-config -g redis_socketio "${REDIS_SOCKETIO}"; fi
if [ -z "${REDIS_CACHE:-}" ] && [ -n "${REDIS_URL:-}" ]; then bench set-config -g redis_cache "${REDIS_URL%/}/${REDIS_DB_CACHE:-1}"; fi
if [ -z "${REDIS_QUEUE:-}" ] && [ -n "${REDIS_URL:-}" ]; then bench set-config -g redis_queue "${REDIS_URL%/}/${REDIS_DB_QUEUE:-2}"; fi
if [ -z "${REDIS_SOCKETIO:-}" ] && [ -n "${REDIS_URL:-}" ]; then bench set-config -g redis_socketio "${REDIS_URL%/}/${REDIS_DB_SOCKETIO:-3}"; fi

# --- 3) Initialize or migrate the site ---
if [ ! -f "$SITE_DIR/site_config.json" ]; then
  echo "ERROR: site_config.json not found"; exit 1
fi

# If the site DB is not initialized yet, new-site will create schema and admin user
if ! bench --site "${SITE_NAME}" list-apps >/dev/null 2>&1; then
  bench new-site "${SITE_NAME}" \
    --no-mariadb-socket \
    --mariadb-host "${DB_HOST}" \
    --mariadb-port "${DB_PORT}" \
    --db-name "${DB_NAME}" \
    --mariadb-root-username "${DB_USER}" \
    --mariadb-root-password "${DB_PASSWORD}" \
    --admin-password "${ADMIN_PASSWORD:-admin}" \
    --no-provision
  bench --site "${SITE_NAME}" install-app lms
else
  bench --site "${SITE_NAME}" migrate
fi

# --- 4) Start all processes via supervisor (web uses gunicorn on $PORT) ---
exec /usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf

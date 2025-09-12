# ---------- Frontend builder (Vue) ----------
FROM node:20-bullseye AS frontend-builder
WORKDIR /src
COPY frontend/package*.json ./frontend/
RUN cd frontend && npm ci
COPY frontend ./frontend
RUN cd frontend && npm run build

# ---------- Final image: official Frappe LMS ----------
FROM ghcr.io/frappe/lms:stable

USER root
# System deps for supervisor
RUN apt-get update && apt-get install -y --no-install-recommends supervisor ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Copy runtime supervisor + entrypoint
COPY ops/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ops/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown -R frappe:frappe /home/frappe /entrypoint.sh

# Copy built frontend where Frappe serves assets
# NOTE: Codex flagged path mismatch; we align to /assets/lms/frontend/
COPY --from=frontend-builder /src/frontend/dist /home/frappe/frappe-bench/sites/assets/lms/frontend

USER frappe
WORKDIR /home/frappe/frappe-bench

# Bake client assets at build time (faster boots)
# If your app needs additional build flags, add here.
RUN bench build --production

# App Platform will inject PORT; default 8080 for local runs
ENV PORT=8080
# Site name we manage in this container
ENV SITE_NAME=${SITE_NAME:-site1.local}

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]

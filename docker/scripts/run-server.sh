#!/bin/bash

set -euo pipefail

BACKEND_STORE_URI="postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DATABASE_NAME}"

mlflow server \
    --backend-store-uri "'${BACKEND_STORE_URI}'" \
    --default-artifact-root "${ARTIFACT_STORE}" \
    --host "${MLFLOW_HOST}" \
    --port "${MLFLOW_PORT}"

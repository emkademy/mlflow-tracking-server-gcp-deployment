#!/bin/bash

MLFLOW_HOST=$(curl --silent http://metadata.google.internal/computeMetadata/v1/instance/attributes/mlflow_host -H "Metadata-Flavor: Google")
MLFLOW_PORT=$(curl --silent http://metadata.google.internal/computeMetadata/v1/instance/attributes/mlflow_port -H "Metadata-Flavor: Google")
ARTIFACT_STORE=$(curl --silent http://metadata.google.internal/computeMetadata/v1/instance/attributes/artifact_store -H "Metadata-Flavor: Google")
POSTGRES_USER=$(curl --silent http://metadata.google.internal/computeMetadata/v1/instance/attributes/postgres_user -H "Metadata-Flavor: Google")
POSTGRES_HOST=$(curl --silent http://metadata.google.internal/computeMetadata/v1/instance/attributes/postgres_host -H "Metadata-Flavor: Google")
POSTGRES_PORT=$(curl --silent http://metadata.google.internal/computeMetadata/v1/instance/attributes/postgres_port -H "Metadata-Flavor: Google")
POSTGRES_DATABASE_NAME=$(curl --silent http://metadata.google.internal/computeMetadata/v1/instance/attributes/postgres_database_name -H "Metadata-Flavor: Google")
POSTGRES_PASSWORD_SECRET_NAME=$(curl --silent http://metadata.google.internal/computeMetadata/v1/instance/attributes/postgres_password_secret_name -H "Metadata-Flavor: Google")
GCP_DOCKER_REGISTERY_URL=$(curl --silent http://metadata.google.internal/computeMetadata/v1/instance/attributes/gcp_docker_registery_url -H "Metadata-Flavor: Google")

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

echo '=========== Downloading Docker Image ============'
gcloud auth configure-docker --quiet europe-west4-docker.pkg.dev
echo "GCP_DOCKER_REGISTERY_URL = ${GCP_DOCKER_REGISTERY_URL}"
time sudo docker pull "${GCP_DOCKER_REGISTERY_URL}"

# systemctl stop jupyter

sudo docker run --init --network host --ipc host --user root --hostname "$(hostname)" --privileged \
  --log-driver=gcplogs \
  -e POSTGRES_USER="${POSTGRES_USER}" \
  -e POSTGRES_PASSWORD=$(gcloud secrets versions access latest --secret="${POSTGRES_PASSWORD_SECRET_NAME}") \
  -e POSTGRES_HOST="${POSTGRES_HOST}" \
  -e POSTGRES_PORT="${POSTGRES_PORT}" \
  -e POSTGRES_DATABASE_NAME="${POSTGRES_DATABASE_NAME}" \
  -e ARTIFACT_STORE="${ARTIFACT_STORE}" \
  -e MLFLOW_HOST="${MLFLOW_HOST}" \
  -e MLFLOW_PORT="${MLFLOW_PORT}" \
  ${GCP_DOCKER_REGISTERY_URL}

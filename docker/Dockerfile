FROM python:3.10-slim

ENV HOME=/root
ENV \
    PYTHONUNBUFFERED=1 \
    VIRTUAL_ENV="${HOME}/venv" \
    PATH="$HOME/venv/bin:/usr/local/gcloud/google-cloud-sdk/bin/:${PATH}" \
    PYTHONPATH="/app:${PYTHONPATH}" \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    BUILD_POETRY_LOCK="${HOME}/poetry.lock.build"

RUN apt-get -qq update \
    && DEBIAN_FRONTEND="noninteractive" apt-get -qq -y install git curl wget vim \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get -qq -y clean

# Install gcloud and gsutils
RUN curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-377.0.0-linux-x86_64.tar.gz > /tmp/google-cloud-sdk.tar.gz
RUN mkdir -p /usr/local/gcloud \
    && tar -C /usr/local/gcloud -xf /tmp/google-cloud-sdk.tar.gz \
    && /usr/local/gcloud/google-cloud-sdk/install.sh --usage-reporting false --command-completion true --bash-completion true --path-update true --quiet

# Make sure gsutil will use the default service account
RUN echo '[GoogleCompute]\nservice_account = default' > /etc/boto.cfg

COPY ./docker/scripts/*.sh /
RUN chmod +x /*.sh

RUN HOME=/tmp pip install --no-cache-dir poetry==1.5.1

COPY ./pyproject.toml ./*.lock /app/
WORKDIR /app

RUN python3.10 -m venv $VIRTUAL_ENV \
    && pip install --upgrade pip setuptools \
    && poetry install --no-dev \
    && cp poetry.lock "${BUILD_POETRY_LOCK}" \
    && rm -rf $HOME/.cache/*

ENTRYPOINT ["/bin/bash"]
CMD ["/run-server.sh"]
EXPOSE 6100

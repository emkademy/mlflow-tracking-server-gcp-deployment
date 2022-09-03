# MLFlow Tracking Server

## Prerequisites

[Install gcloud and gsutil command-line tools.](https://cloud.google.com/sdk/docs/install)

## How to deploy MLFlow Tracking Server on a VM on GCP?

### Step 1) Database creation

MLFlow uses a database in order to store logged parameters, and metrics. This repository assumes that 
you are going to use a serverless PostgreSQL database that is running on GCP. If you would like to
use this repository, you need to create a new serverles PostgreSQL instance on GCP. Please follow these steps:

1. [Create a serverless PostgreSQL instance on GCP](https://console.cloud.google.com/sql/choose-instance-engine),
2. Create a new user: `Users -> ADD USER ACCOUNT`, and save its password to [GCP Secret Manager](https://console.cloud.google.com/security/secret-manager),
3. Create a new database: `Databases -> CREATE DATABASE`,

### Step 2) Create a GSC Bucket

MLFlow needs a large storage to store your artifacts. So you need to create a GCS Bucket for MLFlow:

1. [Create Bucket](https://console.cloud.google.com/storage/browser)

### Step 3) Set Environment Variables

Next, you need create 2 files in order to set some environment variables. Please create these files:

1. `.envs/.gcp`
2. `.envs/.tracking-server`

There is already example of how these files should look like in `.envs` directory:

1. `.envs/.gcp-example`
2. `.envs/.tracking-server-example`

### Step 4) Deployment

After everything is ready you can call: 

```
make deploy IMAGE_TAG=<docker-image-tag>
```

As `IMAGE_TAG`, you can specify anything you like. A docker image will be built and pushed to GCP Docker Registery,
and the given `IMAGE_TAG` will be its tag.

### Step 5) Check if everything is working

Since this setup doesn't use expernal IP, you need ssh tunneling in order to view the web API.

1. Check [VM Instances](https://console.cloud.google.com/compute/instances), to see if your VM was created,
2. Run `gcloud compute ssh <vm-instance-name> --zone <vm-instance-zone> --tunnel-through-iap -- -N -L 610
0:localhost:6100`
3. Check `http://localhost:6100` if your MLFlow instance is running.
4. Run `python ./examples/connecting-to-tracking-server.py` to see if everything is working.

### Step 6) Finally

Happy experimentation! :)

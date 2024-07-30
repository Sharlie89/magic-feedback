# Customer Feedback Application Infrastructure

Welcome! This repository contains the infrastructure code to deploy our customer feedback application, featuring a Python API running on Google Cloud Run. We're using Terraform and Terragrunt to automate the deployment and management of this application.

## Repository Structure

├── Dockerfile
├── README.md
├── api
│   ├── app.py
│   └── requirements.txt
├── environments
│   ├── dev
│   │   ├── api
│   │   │   └── terragrunt.hcl
│   │   └── registry
│   │       └── terragrunt.hcl
│   └── prod
│       ├── api
│       │   └── terragrunt.hcl
│       └── registry
│           └── terragrunt.hcl
└── gcp
    ├── modules
    │   ├── artifact-registry
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── iam
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   └── vpc
    │       ├── main.tf
    │       ├── outputs.tf
    │       └── variables.tf
    └── profiles
        ├── infra-api
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── variables.tf
        └── infra-registry
            ├── main.tf
            ├── output.tf
            └── variables.tf



## Prerequisites

Make sure you have the following installed before you start:

- [Terraform](https://www.terraform.io/downloads.html)
- [Terragrunt](https://terragrunt.gruntwork.io/)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- Docker

## Deployment Steps

### 1. Authenticate with Google Cloud

First, authenticate with Google Cloud:

```sh
gcloud auth login
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID
```

### 2. Set Up the Artifact Registry

Go to the registry directory for your environment and deploy the Artifact Registry:

```
cd environments/dev/registry  # For the development environment
# or
cd environments/prod/registry  # For the production environment
```

Then initialize and apply the configuration:

```
terragrunt init
terragrunt apply
```

NOTE: Same steps can be used for the API.

## Cleaning Up

To remove the resources, use terragrunt destroy in the respective directories:

```
# Destroy API resources
cd environments/dev/api  # or environments/prod/api
terragrunt destroy

# Destroy Artifact Registry
cd environments/dev/registry  # or environments/prod/registry
terragrunt destroy
```
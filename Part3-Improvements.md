# Improvements

In this document I will share some of the improvements that can be done to this scenario.
But first, let's do a little analysis of the current setup.

# Current Setup
Let's go to divide it in 2 parts:
-   **Infrastructure**:   
    -   Google Cloud Run for the API deployment.
    -   Terraform and Terragrunt for Infrastructure as Code (IaC).
    -   VPC, subnets, and firewall rules for network configuration.
    -   Artifact Registry for Docker image storage.
-   **CI/CD Pipeline**:
    -   Separate pipelines for deploying Terraform/Terragrunt configurations and the API Docker image.
    -   Stages for validation, planning, and deployment in the Terraform pipeline.
    -   Stages for building, testing, and deploying in the API pipeline.
    -   Manual triggers for production deployments.


## Areas for improvement (short term)

#### 1. Scalability
-   **Horizontal Scaling**: Ensure the Cloud Run service can handle increased load by enabling autoscaling based on request count or CPU utilization.
-   **Terraform State Management**: Use a remote backend ( for example Google Cloud Storage) for storing Terraform state to handle collaborative work better.

#### 2. Security
-   **Service Accounts and Permissions**: Ensure that least privilege principles are applied to service accounts used in the deployments.
-   **Secret Management**: Use Google Secret Manager for managing sensitive data like database credentials, API keys, etc. (In a production environment this will be used)
-   **Network Security**: Implement stricter firewall rules to limit access to the API only from necessary sources.

#### 3. Efficiency
-   **CI/CD Optimization**: Utilize caching for dependencies in CI/CD pipelines to speed up the build process.
-   **Environment Configuration**: Use environment-specific configurations and secrets managed through environment variables.

#### 4. Organization
 - **Repositories**: separate IaC from API code.


## Areas of improvement (long term)

#### 1- Scalability 
- **Migrate to GKE**: migrate from Cloud run to Kubernetes will allow the company to have more control about used resources using a shared platform while keeping client environments isolated from the others (using kubernetes namespaces), brings the possibility of reuse code just using variables for configuration and also will allow us to scale vertical and horizontally.
- 

## Proposed next steps

Following the short terms improvement list:
-   **Enhance Scalability**
    
    -   **Enable Autoscaling**: Configure autoscaling for Cloud Run to handle different loads efficiently.
         ```terraform
        resource "google_cloud_run_service" "service" {
          name     = var.service_name
          location = var.region
        
          template {
            spec {
              containers {
                image = var.image
                ports {
                  container_port = 8080
                }
                resources {
                  limits {
                    cpu    = "1"
                    memory = "256Mi"
                  }
                }
              }
              autoscaling {
                min_instances = 1
                max_instances = 10
              }
            }
          }
        
          traffic {
            percent         = 100
            latest_revision = true
          }
        }        
        ```
    
    -   **Remote State Management**: Configure Terraform to use Google Cloud Storage for remote state management.

        ```terraform
            terraform {
              backend "gcs" {
                bucket = "terraform-state-bucket"
                prefix = "terraform/state"
             }
            }
        ```
-   **Improve Security**
    
    -   **Apply Least Privilege**: Audit and adjust the permissions of service accounts to follow the least privilege principle.
    -   **Integrate Secret Manager**: Store and access sensitive data through Google Secret Manager.
    -   **Network Policies**: Implement stricter firewall rules and possibly use VPC Service Controls for enhanced security.
-   **Optimize CI/CD Pipeline**
    
    -   **Dependency Caching**: Implement caching for Docker layers and Python dependencies in GitLab CI/CD to speed up the build process.
        ```yaml
        # .gitlab-ci/deploy-api.yml

        stages:
          - build
          - test
          - deploy

        variables:
          PROJECT_ID: your-project-id
          REGION: us-central1
          REPO_NAME: repo-name
          IMAGE_NAME: docker-image
          TAG: latest

        before_script:
          - echo $GCLOUD_SERVICE_KEY | base64 -d > ${CI_PROJECT_DIR}/gcloud-service-key.json
          - gcloud auth activate-service-account --key-file=${CI_PROJECT_DIR}/gcloud-service-key.json
          - gcloud --quiet config set project $PROJECT_ID
          - gcloud auth configure-docker $REGION-docker.pkg.dev

        cache:
          key: ${CI_COMMIT_REF_SLUG}
          paths:
            - .cache/pip
            - api/__pycache__

        build:
          stage: build
          script:
            - docker build -t $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$TAG .
          artifacts:
            paths:
              - $CI_PROJECT_DIR
        
        test:
          stage: test
          script:
            - docker run --rm $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$TAG pytest api/tests
          dependencies:
            - build
        
        deploy:
          stage: deploy
          script:
            - docker push $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$TAG
            - gcloud run deploy $IMAGE_NAME --image $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$TAG --platform managed --region $REGION --allow-unauthenticated
          environment:
            name: $ENVIRONMENT
          rules:
            - if: $CI_COMMIT_REF_NAME == "main"
            - if: $CI_COMMIT_TAG
            - when: manual 
        ```
    - **Environment-Specific Configurations**: Use environment variables and GitLab CI/CD environment-specific configurations for managing secrets and configurations.

-   **Facilitate API-Frontend Integration**    
    -   **API Documentation**: Use tools like Swagger or Postman to document the API endpoints.
    -   **Versioning**: Implement API versioning to ensure backward compatibility as the API evolves.

**NOTE**: all this code blocks are just a quick draw.

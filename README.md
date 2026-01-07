## Architecture

*   **Application**: Simple Python Flask API with endpoints:
    *   `/` : Returns "Hello World"
    *   `/health` : Health check endpoint
*   **Infrastructure** (Terraform):
    *   **VPC**: Custom VPC with public subnets.
    *   **ECS Cluster**: Fargate cluster (`hello-world-cluster`).
    *   **ECR Repo**: Docker image repository (`hello-world-app`).
    *   **ECS Service**: Runs the app in a Fargate task.
    *   **Security Groups**: Allows traffic on port `8080`.
*   **CI/CD** (GitHub Actions):
    *   Tests the Python app.
    *   Builds Docker image.
    *   Pushes to AWS ECR.
    *   Forces a new deployment on ECS.

## Prerequisites

1.  **AWS CLI** installed and configured locally.
2.  **Terraform** installed (v1.0+).
3.  **Docker** installed (for local testing).
4.  **GitHub Repository Secrets** configured:
    *   `AWS_ACCESS_KEY_ID`
    *   `AWS_SECRET_ACCESS_KEY`ß

## Deployment Instructions

### 1. Provision Infrastructure
First, create the ECR repository and ECS cluster using Terraform.

```bash
cd terraform
terraform init
terraform apply
```

### 2. Deploy Application
Push your code to the `main` branch. This triggers the GitHub Actions workflow which will:
1.  Run tests.
2.  Build the Docker image with `curl` installed (for health checks).
3.  Push the image to ECR.
4.  Update the ECS Service to use the new image.

### 3. Access the Application
Since we removed the Load Balancer for simplicity, the app runs on a public IP.

1.  Go to **AWS Console** -> **Amazon ECS**.
2.  Open **Clusters** -> `hello-world-cluster` -> **Tasks**.
3.  Click on the running Task ID.
4.  Find the **Public IP**.
5.  Open in browser: `http://<PUBLIC_IP>:8080/`

## 4. Monitoring & Health Checks

*   **Container Health**: The `Dockerfile` installs `curl` and runs a health check every 30s against `http://localhost:8080/health`.
*   **Auto-Recovery**: ECS is configured (`ecs.tf`) to monitor this health check. If it fails 3 times, ECS automatically stops the task and starts a fresh one.
*   **Logs**: Application logs are sent to CloudWatch Log Group: `/ecs/hello-world-app`.

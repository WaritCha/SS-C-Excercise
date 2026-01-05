# Testing & Verification Guide

This document provides step-by-step instructions for testing the application, verifying infrastructure with Terraform, and monitoring the CI/CD pipeline.

## 1. Application Testing (Local)

Before pushing changes, run tests locally to ensure code quality.

### Prerequisites
*   Python 3.9+
*   Docker (optional, for container testing)

### Setup
Install the required dependencies:
```bash
python3 -m pip install -r app/requirements.txt
```

### Unit Tests
Run the unit tests to verify individual components:
```bash
# Run from the repository root
export PYTHONPATH=$PYTHONPATH:$(pwd)/app
pytest app/tests/test_app.py
```

### Local Run
Start the Flask application locally:
```bash
python3 app/app.py
```
The app will be available at [http://localhost:8080](http://localhost:8080).

### Integration Tests
With the app running locally, open a new terminal and run integration tests:
```bash
# This script targets http://localhost:8080 by default
python3 app/tests/integration_test.py
```

## 2. Infrastructure Verification (Terraform)

Use Terraform commands to validate infrastructure changes before applying.

### Commands
```bash
cd terraform

# 1. Initialize Terraform (downloads providers)
terraform init

# 2. Validate configuration syntax
terraform validate

# 3. Preview changes (Dry Run)
terraform plan
```
> [!NOTE]
> Ensure you have your AWS credentials configured safely before running `terraform plan`.

## 3. CI/CD Pipeline (GitHub Actions)

The deployment pipeline is defined in `.github/workflows/deploy.yml`.

### Triggers
*   **Push to `main`**: Automatically triggers the entire pipeline (Test -> Build -> Push -> Deploy).
*   **Pull Request to `main`**: Triggers only the **Test** job to ensure code quality before merging.

### Pipeline Stages
1.  **Test**: Sets up Python, installs dependencies, and runs `pytest`.
2.  **Build-and-Push**:
    *   Logs into Amazon ECR.
    *   Builds the Docker image.
    *   Tags it with the Git SHA and `latest`.
    *   Pushes the image to ECR.
    *   Updates `k8s/deployment.yaml` with the new image tag and pushes the change back to the repository (GitOps pattern).

### Monitoring
Check the **Actions** tab in your GitHub repository to view the progress and logs of each run.

## 4. Post-Deployment Verification (Kubernetes)

After the pipeline completes and ArgoCD syncs the changes (or you apply them manually):

### Check Status
```bash
# Verify Pods are running
kubectl get pods

# Verify Service IP/URL
kubectl get service hello-world-service
```

### Access Application
If using a LoadBalancer, use the external IP. For private clusters or testing:
```bash
Then visit [http://localhost:8080](http://localhost:8080) / [http://localhost:8080/health](http://localhost:8080/health).

## 5. Observability Verification

### Metrics
The application exposes Prometheus metrics at `/metrics`.
1.  Run the app locally or port-forward the service.
2.  Visit [http://localhost:8080/metrics](http://localhost:8080/metrics).
3.  You should see standard Python/Flask metrics (e.g., `flask_http_request_total`).

### Logs
1.  Go to the **AWS Console > CloudWatch > Log Groups**.
2.  Find the group named `/aws/eks/hello-world-eks/cluster`.
3.  You will see log streams for `kube-apiserver`, `kube-scheduler`, etc.


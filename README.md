# SRE Tech Challenge

This repository contains the solutions to the SRE Tech Challenge.

## Tasks

### Task 1: Provision Kubernetes Cluster
- **Status**: Completed
- **Description**: A Google Kubernetes Engine (GKE) cluster was provisioned using Terraform. Key aspects include enabling autoscaling, configuring node pools, and setting up appropriate service account permissions.
- **Testing**: Autoscaling was tested by simulating workloads, ensuring the cluster could scale up and down based on demand.
- **Production Readiness**: Discusses high availability, security, scalability, and disaster recovery considerations.
- **Related Pull Request**: [Task 1 PR](https://github.com/cmclean90/sre-tech-challenge/pull/1)
- **Detailed Documentation**: [Task 1 Documentation](./documentation/task1_k8s_cluster.md)

### Task 2: Deploy ArgoCD
- **Status**: Completed
- **Description**: ArgoCD was deployed using Helm in the `argo` namespace, allowing for application management and GitOps-style deployments. A hashed admin password was securely passed via Terraform.
- **Testing**: Deployed a sample Helm application (`test-app`) to ensure ArgoCD was functioning correctly. The app's sync status and health were verified in the ArgoCD dashboard.
- **Production Readiness**: Security, scalability, and disaster recovery considerations were documented for production environments.
- **Related Pull Request**: [Task 2 PR](https://github.com/cmclean90/sre-tech-challenge/pull/2)
- **Detailed Documentation**: [Task 2 Documentation](./documentation/task2_argocd_deployment.md)

### Task 3: Deploy Keycloak for User Authentication with ArgoCD
- **Status**: Completed
- **Description**: Keycloak was deployed using Helm in the `identity` namespace and integrated with ArgoCD using OpenID Connect (OIDC) for authentication. The `identity` namespace was created via Terraform, and Keycloak was deployed and configured through ArgoCD to manage user authentication.
- **Testing**: Verified the Keycloak login functionality and the OIDC integration with ArgoCD. Authentication via Keycloak for ArgoCD was confirmed, and users were able to log in successfully.
- **Production Readiness**: Considerations around high availability, security, scalability, and disaster recovery were documented.
- **Related Pull Request**: [Task 3 PR](https://github.com/cmclean90/sre-tech-challenge/pull/5)
- **Detailed Documentation**: [Task 3 Documentation](./documentation/task3_keycloak.md)

### Optional Task 3: Deploy Monitoring (Prometheus and Grafana)
- **Status**: Completed
- **Description**: A monitoring stack using **Prometheus** and **Grafana** was deployed in the `observability` namespace via Terraform and Helm. Custom Grafana dashboards for **ArgoCD** and **Keycloak** were configured, alongside out-of-the-box dashboards and alerts from the **kube-prometheus-stack**. Metrics scraping was enabled for both **ArgoCD** and **Keycloak** using ServiceMonitor and PodMonitor resources.
- **Testing**: Metrics endpoints were validated for Prometheus scraping using `curl`. Grafana dashboards were tested to confirm metrics visualization.
- **Production Readiness**: Recommendations were made for alerting, high availability, security, and disaster recovery.
- **Related Pull Request**: [Optional Task 3 PR](https://github.com/cmclean90/sre-tech-challenge/pull/7)
- **Detailed Documentation**: [Optional Task 3 Documentation](./documentation/optional_task3_monitoring.md)

## How to Run
*This section will be updated once the repository contains full instructions on how to deploy the entire stack.*

### Running Terraform for Task 1:
1. Clone the repository:
   ```bash
   git clone https://github.com/cmclean90/sre-tech-challenge.git
   cd sre-tech-challenge
2. Make sure you have the required Google Cloud credentials set up. Set the environment variable pointing to your credentials file:
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/credentials-file.json"
3. Initialise Terraform:
   ```bash
   terraform init
4. Apply the Terraform to provision the GKE cluster:
   ```bash
   terraform apply
5. Once the cluster is deployed, you can verify its status by using K9s or kubectl.

## Notes

- Ensure that the appropriate Google Cloud credentials are configured before applying Terraform.
- The Terraform state is managed in a GCS bucket to maintain consistency and enable recovery.


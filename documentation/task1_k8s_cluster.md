# Task 1: Provision Kubernetes Cluster

## Overview
This document outlines the steps taken to provision a Google Kubernetes Engine (GKE) cluster as part of the SRE Tech Challenge. The cluster is set up using Terraform, with autoscaling, node pools, and IP aliasing enabled for efficient resource management.

## Steps

### 1. Provisioning the Cluster
- Terraform was used to define and provision the GKE cluster.
- Cluster setup included:
  - **Autoscaling** with a minimum of 1 node and a maximum of 5 nodes.
  - **IP aliasing** enabled for better network resource management.
  - Defined **node pools** with specified machine types (`e2-medium`) and OAuth scopes.

Relevant files:
- [Terraform main configuration file](../main.tf)
- [Variables](../variables.tf)
- [IAM Configuration](../iam.tf)
- [Storage Buckets Configuration](../storage-buckets.tf)

### 2. Service Account Management
- A dedicated SA (`terraform-sa`) was created with the following roles:
  - **Compute Network Admin**
  - **Kubernetes Engine Admin**
  - **Service Account User**
- The SA is configured to manage its own IAM permissions via Terraform, using the `roles/resourcemanager.projectIamAdmin` role.

Relevant files:
- [IAM Configuration](../iam.tf)

### 3. Storage Buckets for Terraform State
- A Google Cloud Storage (GCS) bucket was created for storing the Terraform state, ensuring proper state management and allowing for easier disaster recovery.

Relevant files:
- [Storage Buckets Configuration](../storage-buckets.tf)
- [Terraform Backend Configuration](../backend.tf)

## Configuration Details
- The Terraform configuration for the GKE cluster is available in the [Terraform main configuration file](../main.tf).
- **IAM policies** were configured for the SA to ensure proper role-based access control.

## Testing
- **Cluster Accessibility**: Verified that the GKE cluster is accessible via **K9s**, a terminal UI for managing Kubernetes clusters.
- **Autoscaling**: Tested autoscaling by simulating workloads, ensuring the cluster scaled up and down based on demand.
- **Node Health**: Verified that nodes in the cluster were functioning properly by checking node status and resource usage using **K9s**.

## Production Readiness Considerations

### High Availability
- **Current Setup**: Autoscaling is enabled to dynamically adjust the number of nodes based on workload.
- **Production Improvements**: For production, multi-region clusters should be implemented, ensuring the system remains functional in the event of regional failures. Global load balancers should also be used to distribute traffic across regions.

### Security
- **Current Setup**: IAM roles were set up for the SA to restrict access to necessary resources. The Terraform state is stored securely in a GCS bucket.
- **Production Improvements**: In a production environment, I would would implement:
  - **Network policies** and **firewall rules** to control traffic between services.
  - **Secrets management** to securely store sensitive information.
  - **Regular credential/key rotation** and the use of tools like Google Secret Manager for secure storage.

### Scalability
- **Current Setup**: Autoscaling is enabled in the GKE cluster to ensure it can dynamically adjust to different workloads.
- **Production Improvements**: Additional scaling should be implemented at the application level using **horizontal pod autoscaling (HPA)**. This would allow services to scale based on CPU, memory, or custom prometheus metrics.

### Disaster Recovery
- **Current Setup**: Terraform state is stored in a GCS bucket, enabling recovery of the infrastructure if necessary.
- **Production Improvements**: In production, I would:
  - Implement **automatic backups** for data and services.
  - Set up **multi-region disaster recovery** with replication of key components across regions.
  - Regularly test **disaster recovery plans** to ensure fast recovery in case of failure.

### Monitoring and Observability
- **Current Setup**: No monitoring implemented yet (will be completed in optional task).
- **Production Improvements**: I would implement centralised logging (using Google Cloud Logging) and set up **monitoring and alerting** with Prometheus and Grafana. Additionally, defining **SLOs** and **SLIs** to monitor performance and reliability would be critical in production.

## Related PR
- [Task 1: Provision GKE Cluster](https://github.com/cmclean90/sre-tech-challenge/pull/1)
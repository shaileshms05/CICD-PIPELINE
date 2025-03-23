# E-Commerce Website Deployment using Jenkins, SonarQube, Docker, and Terraform

## Overview
This project sets up an automated **CI/CD pipeline** to deploy an **E-commerce website** using:
- **Terraform** to provision EC2 instances for Jenkins, SonarQube, and Docker.
- **Jenkins** for continuous integration and deployment.
- **SonarQube** for static code analysis.
- **Docker** for containerized application deployment.

## Infrastructure Setup
We use **Terraform** to create the following **AWS EC2 instances**:
1. **Jenkins Server** (for CI/CD pipeline automation)
2. **SonarQube Server** (for code quality checks)
3. **Docker Host** (to run the website container)

### Steps to Set Up Infrastructure
1. Install **Terraform** on your local machine.
2. Clone the repository:
   ```sh
   git clone https://github.com/your-repo/ecommerce-deployment.git
   cd ecommerce-deployment
   ```
3. Initialize Terraform:
   ```sh
   terraform init
   ```
4. Apply Terraform to create EC2 instances:
   ```sh
   terraform apply -auto-approve
   ```

## CI/CD Pipeline
We use **Jenkins** to automate the deployment process:

### Jenkins Pipeline (Jenkinsfile)
1. **Pull Code** from GitHub.
2. **Run SonarQube Analysis** for code quality.
3. **Build Docker Image** and push it to Docker Hub.
4. **Deploy the Container** on the EC2 Docker instance.

### Setting Up Jenkins
1. Install Jenkins and required plugins (**Pipeline, Docker, SonarQube Scanner**).
2. Configure Jenkins with **GitHub Webhooks**.
3. Add **SonarQube Credentials** in Jenkins.
4. Set up the pipeline using the `Jenkinsfile` from the repo.

## SonarQube Configuration
1. Access SonarQube at `http://<sonarqube-ec2-ip>:9000`
2. Generate a **SonarQube Token** for Jenkins integration.
3. Add the token in Jenkins under **Manage Jenkins > Credentials**.

## Docker Deployment
1. Build and run the Docker container:
   ```sh
   docker build -t ecommerce-app .
   docker run -d -p 80:80 ecommerce-app
   ```
2. The website will be available at `http://<docker-ec2-ip>`.

## CI/CD Workflow
1. Developer pushes code to **GitHub**.
2. **Jenkins** triggers the pipeline.
3. **SonarQube** analyzes the code.
4. **Docker Image** is built and pushed to **Docker Hub**.
5. The application is deployed on the **Docker EC2 instance**.
6. Website is live on **AWS EC2**.

## Repository Structure
```
├── terraform/
│   ├── main.tf  # Terraform configuration
│   ├── variables.tf
│   ├── outputs.tf
├── jenkins/
│   ├── Jenkinsfile  # CI/CD pipeline
├── app/
│   ├── Dockerfile   # Application containerization
│   ├── index.html   # Web files
│   ├── server.py    # Backend code
└── README.md        # Documentation
```

## Future Enhancements
- Auto-scaling of EC2 instances.
- Integrating **Kubernetes** for container orchestration.
- Implementing **AWS CodeDeploy** for zero-downtime deployments.

---
This setup ensures **automated, scalable, and high-quality deployment** for your E-commerce website! 🚀


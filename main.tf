provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

# Define the AMI and instance type (adjust based on your needs)
variable "ami_id" {
  default = "ami-0c55b159cbfafe1f0"  # Example AMI, update accordingly
}

variable "instance_type" {
  default = "t2.medium"
}

variable "key_name" {
  default = "your-key-pair"  # Change to your key pair
}

# Create Security Group
resource "aws_security_group" "cicd_sg" {
  name        = "cicd_security_group"
  description = "Allow SSH, HTTP, and custom ports for CI/CD tools"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For Jenkins
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For SonarQube
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Web server
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTPS
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Jenkins EC2 Instance
resource "aws_instance" "jenkins" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.cicd_sg.name]

  tags = {
    Name = "Jenkins-Server"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y java-11-openjdk
              sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
              sudo yum install -y jenkins
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              EOF
}

# Create SonarQube EC2 Instance
resource "aws_instance" "sonarqube" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.cicd_sg.name]

  tags = {
    Name = "SonarQube-Server"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y java-11-openjdk
              sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.zip
              sudo yum install -y unzip
              sudo unzip sonarqube-9.9.0.zip -d /opt/
              sudo mv /opt/sonarqube-* /opt/sonarqube
              sudo adduser sonar
              sudo chown -R sonar:sonar /opt/sonarqube
              sudo su - sonar -c "/opt/sonarqube/bin/linux-x86-64/sonar.sh start"
              EOF
}

# Create Docker EC2 Instance
resource "aws_instance" "docker" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.cicd_sg.name]

  tags = {
    Name = "Docker-Server"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y docker
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ec2-user
              EOF
}

# Output public IPs
output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "sonarqube_public_ip" {
  value = aws_instance.sonarqube.public_ip
}

output "docker_public_ip" {
  value = aws_instance.docker.public_ip
}

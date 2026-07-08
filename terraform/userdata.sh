#!/bin/bash

# Update the system
dnf update -y

# Install Git
dnf install -y git

# Install Docker
dnf install -y docker

# Enable and start Docker
systemctl enable docker
systemctl start docker

# Allow ec2-user to use Docker
usermod -aG docker ec2-user

# Clone the repository
cd /home/ec2-user

git clone https://github.com/simeonprimordial/fintrust-nlb-docker.git

cd fintrust-nlb-docker

# Build Docker image
docker build \
-f docker/Dockerfile \
-t fintrust-status-service:1.0 .

# Run Docker container
docker run -d \
--name fintrust-app \
-p 5000:5000 \
--restart unless-stopped \
fintrust-status-service:1.0

# Fix ownership
chown -R ec2-user:ec2-user /home/ec2-user/fintrust-nlb-docker
############################################
# EC2 Security Group
############################################

resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ec2-sg"
  description = "Allow HTTP traffic from the Network Load Balancer"
  vpc_id      = data.aws_vpc.default.id


ingress {
  description = "Flask application from NLB"
  from_port   = var.target_port
  to_port     = var.target_port
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    # Replace with your public IP in CIDR notation, e.g. "203.0.113.10/32"
    cidr_blocks = ["102.88.108.34/32"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
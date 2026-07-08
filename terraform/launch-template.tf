############################################
# Latest Amazon Linux 2023 AMI
############################################

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

############################################
# Launch Template
############################################

resource "aws_launch_template" "web_launch_template" {

  name_prefix = "${var.project_name}-lt-"

  image_id = data.aws_ami.amazon_linux.id

  instance_type = var.instance_type

  key_name = var.key_pair_name

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  user_data = base64encode(file("${path.module}/userdata.sh"))

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name = "Apache-Web-Server"
    }
  }
}
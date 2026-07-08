#!/bin/bash

dnf update -y

dnf install -y httpd

systemctl enable httpd

systemctl start httpd

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Highly Available Web App</title>
</head>
<body style="font-family: Arial; text-align:center; margin-top:50px;">
    <h1>Highly Available Web Application</h1>
    <h2>Provisioned with Terraform</h2>
    <p><strong>Hostname:</strong> $(hostname -f)</p>
</body>
</html>
EOF
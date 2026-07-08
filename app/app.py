from flask import Flask, render_template
import socket
import requests
from datetime import datetime

app = Flask(__name__)


def get_metadata(path):
    """Retrieve EC2 instance metadata using IMDSv2."""
    try:
        token = requests.put(
            "http://169.254.169.254/latest/api/token",
            headers={
                "X-aws-ec2-metadata-token-ttl-seconds": "21600"
            },
            timeout=2
        ).text

        response = requests.get(
            f"http://169.254.169.254/latest/meta-data/{path}",
            headers={
                "X-aws-ec2-metadata-token": token
            },
            timeout=2
        )

        return response.text

    except Exception:
        return "Unavailable"


@app.route("/")
def home():

    hostname = socket.gethostname()

    instance_id = get_metadata("instance-id")

    availability_zone = get_metadata("placement/availability-zone")

    private_ip = get_metadata("local-ipv4")

    region = (
        availability_zone[:-1]
        if availability_zone != "Unavailable"
        else "Unavailable"
    )

    current_time = datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S UTC")

    return render_template(
        "index.html",
        hostname=hostname,
        instance_id=instance_id,
        private_ip=private_ip,
        availability_zone=availability_zone,
        region=region,
        current_time=current_time
    )

@app.route("/health")
def health():
    return {
        "status": "healthy",
        "application": "FinTrust Status Service"
    }, 200

@app.route("/info")
def info():

    hostname = socket.gethostname()

    instance_id = get_metadata("instance-id")

    availability_zone = get_metadata("placement/availability-zone")

    private_ip = get_metadata("local-ipv4")

    region = (
        availability_zone[:-1]
        if availability_zone != "Unavailable"
        else "Unavailable"
    )

    return {
        "application": "FinTrust Status Service",
        "hostname": hostname,
        "instance_id": instance_id,
        "private_ip": private_ip,
        "availability_zone": availability_zone,
        "region": region,
        "container": "Docker",
        "load_balancer": "Network Load Balancer",
        "orchestration": "Auto Scaling Group",
        "infrastructure": "Terraform"
    }

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
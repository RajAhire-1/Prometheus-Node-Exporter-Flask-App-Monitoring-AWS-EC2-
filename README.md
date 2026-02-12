# 🚀 Prometheus + Node Exporter + Flask App Monitoring (AWS EC2)

## 📌 Project Overview

This project demonstrates:

* ✅ Prometheus Installation on EC2
* ✅ Node Exporter Setup
* ✅ Custom Python Flask Application
* ✅ Prometheus Custom Metrics Integration
* ✅ System Monitoring (CPU, Requests, Errors, Latency)
* ✅ AWS Security Group Configuration

This is a **Production-style Monitoring Setup** built on AWS.

---

# 🏗 Architecture

```
User → Flask App (Port 5000)
             ↓
       /metrics endpoint
             ↓
        Prometheus (9090)
             ↓
        Node Exporter (9100)
```

---

# ☁️ AWS Setup

### EC2 Configuration

| Component     | Value            |
| ------------- | ---------------- |
| Instance Type | t3.micro         |
| OS            | Ubuntu 22.04 LTS |

### 🔐 Security Group Ports Opened

| Port | Purpose       |
| ---- | ------------- |
| 22   | SSH           |
| 9090 | Prometheus    |
| 9100 | Node Exporter |
| 5000 | Flask App     |
| 3000 | Grafana       |

Source: `0.0.0.0/0`

---

# 📦 Installation Steps

## 1️⃣ Install Prometheus

```bash
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
```

Download:

```bash
wget https://github.com/prometheus/prometheus/releases/download/v2.53.1/prometheus-2.53.1.linux-amd64.tar.gz
```

Create service:

```
/etc/systemd/system/prometheus.service
```

Start:

```bash
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
```

Access:

```
http://PUBLIC_IP:9090
```

---

## 2️⃣ Install Node Exporter

```bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz
```

Create service:

```
/etc/systemd/system/node_exporter.service
```

Start:

```bash
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
```

Access:

```
http://PUBLIC_IP:9100
```

---

## 3️⃣ Flask Monitoring App

### Install Dependencies

```bash
sudo apt install python3-pip python3-venv -y
python3 -m venv myenv
source myenv/bin/activate
pip install flask prometheus_client
```

---

## 📄 app.py

```python
from flask import Flask, request
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import time
import random

app = Flask(__name__)

REQUEST_COUNT = Counter(
    'app_requests_total',
    'Total HTTP Requests',
    ['method', 'endpoint', 'http_status']
)

ERROR_COUNT = Counter(
    'app_errors_total',
    'Total Error Responses'
)

REQUEST_LATENCY = Histogram(
    'app_request_latency_seconds',
    'Request latency',
    ['endpoint']
)

@app.route('/')
def home():
    start_time = time.time()
    time.sleep(random.uniform(0.1, 0.5))
    status = 200
    REQUEST_COUNT.labels(request.method, '/', status).inc()
    REQUEST_LATENCY.labels('/').observe(time.time() - start_time)
    return "🚀 Welcome to DevOps Monitoring App!", status

@app.route('/about')
def about():
    start_time = time.time()
    status = 200
    REQUEST_COUNT.labels(request.method, '/about', status).inc()
    REQUEST_LATENCY.labels('/about').observe(time.time() - start_time)
    return "Production Ready Flask App with Prometheus Monitoring", status

@app.route('/error')
def error():
    ERROR_COUNT.inc()
    REQUEST_COUNT.labels(request.method, '/error', 500).inc()
    return "❌ Something went wrong!", 500

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

Run:

```bash
nohup python3 app.py > app.log 2>&1 &
```

---

# ⚙ Prometheus Configuration

File:

```
/etc/prometheus/prometheus.yml
```

Add:

```yaml
- job_name: 'node_exporter'
  static_configs:
    - targets: ['localhost:9100']

- job_name: 'python_app'
  static_configs:
    - targets: ['localhost:5000']
```

Restart:

```bash
sudo systemctl restart prometheus
```

---

# 📊 Prometheus Queries

### Total Requests

```
app_requests_total
```

### Error Rate

```
rate(app_errors_total[1m])
```

### CPU Usage

```
100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

### Average Latency

```
rate(app_request_latency_seconds_sum[5m]) 
/
rate(app_request_latency_seconds_count[5m])
```

---

# 📸 Screenshots

Add your screenshots inside a folder:

```
screenshots/
```

Example:

```
screenshots/prometheus.png
screenshots/node_exporter.png
screenshots/metrics_graph.png
```

Then reference like:

```markdown
![Prometheus UI](screenshots/prometheus.png)
```

---

# 🎯 Skills Demonstrated

* AWS EC2 Setup
* Linux Administration
* Systemd Services
* Prometheus Installation
* Node Exporter Setup
* Flask Monitoring
* Custom Metrics
* DevOps Monitoring Architecture

---



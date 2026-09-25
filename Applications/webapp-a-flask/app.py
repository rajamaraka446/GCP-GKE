from flask import Flask, jsonify
from prometheus_client import Counter, Histogram, generate_latest
import logging
import os
import time

app = Flask(__name__)

logging.basicConfig(level=logging.INFO)

REQUEST_COUNT = Counter("http_requests_total", "Total HTTP Requests")
REQUEST_LATENCY = Histogram("http_request_duration_seconds", "Request latency")


@app.before_request
def before_request():
    REQUEST_COUNT.inc()


@app.route("/")
@REQUEST_LATENCY.time()
def home():
    logging.info("Request received")
    return jsonify({
        "application": "WebApp-A",
        "status": "Running",
        "environment": os.getenv("ENV", "prod")
    })


@app.route("/health")
def health():
    return jsonify(status="healthy"), 200


@app.route("/ready")
def ready():
    return jsonify(status="ready"), 200


@app.route("/metrics")
def metrics():
    return generate_latest(), 200, {
        "Content-Type": "text/plain; version=0.0.4"
    }


@app.route("/sleep/<int:seconds>")
def sleep(seconds):
    time.sleep(seconds)
    return jsonify(slept=seconds)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)

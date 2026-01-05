import logging
import sys
import time
import os
from flask import Flask, request
from prometheus_flask_exporter import PrometheusMetrics

# Configure structured logging
logging.basicConfig(
    stream=sys.stdout,
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

app = Flask(__name__)
metrics = PrometheusMetrics(app)

port = int(os.environ.get("PORT", 8080))

@app.before_request
def log_request():
    app.logger.info(f"Incoming Request: {request.method} {request.path}")

@app.after_request
def log_response(response):
    app.logger.info(f"Response Status: {response.status}")
    return response

@app.route('/')
def hello():
    logger.info("Root endpoint hit")
    return "Hello World"

@app.route('/health')
def health():
    return "OK", 200

@app.errorhandler(404)
def not_found(error):
    return "404: Page not found", 404

@app.errorhandler(500)
def internal_error(error):
    return "500: Internal Server Error", 500


if __name__ == '__main__':
    print(f"Starting application on port {port}...")
    app.run(host='0.0.0.0', port=port)

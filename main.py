from flask import Flask
from prometheus_flask_exporter import PrometheusMetrics


app = Flask(__name__)
metrics = PrometheusMetrics(app)


@app.route('/')
def index():
    return {
        'status': '200'
    }


app.run(host='0.0.0.0', port=8080)
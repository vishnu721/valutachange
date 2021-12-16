from flask import Flask, jsonify
import requests
app = Flask(__name__)

@app.route('/', methods=['GET'])
def info():
    # Some logic to connect to the RDS DB and fetch data
    return jsonify({'data': 'hi from m2' })


if __name__ == '__main__':
   app.run(host='0.0.0.0', port=5001)

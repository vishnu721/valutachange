from flask import Flask, jsonify
import requests
app = Flask(__name__)

@app.route('/getInfo', methods=['GET'])
def get_info():
    content = requests.get('http://m2-service:5001/')
    data = content.json()   
    return jsonify({'message from m1': 'Hi from m1', 'message from m2': data['data'] })


if __name__ == '__main__':
   app.run()
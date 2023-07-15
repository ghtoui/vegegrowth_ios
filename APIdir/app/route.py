from flask import jsonify, request
from app import app
import time

# GETリクエストに対応するエンドポイント
@app.route('/api/data', methods = ['GET'])
def get_data():
    data = []
    time.sleep(3)
    for i in range(10):
        data.append({'name': 'test{}'.format(i)})

    return jsonify(data)

@app.route('/api/send_data', methods = ['POST'])
def post_data():
    req_data = request.get_json()
    # keyで取得できる
    message = req_data.get('message')
    print(message)
    response = {'message': 'Receive: {}'.format(message)}
    return jsonify(response)


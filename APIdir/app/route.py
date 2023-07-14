from flask import jsonify, request
from app import app

# GETリクエストに対応するエンドポイント
@app.route('/api/data', methods = ['GET'])
def get_data():
    data = {'message': 'hello~~'}
    return jsonify(data)

@app.route('/api/data', methods = ['POST'])
def post_data():
    req_data = request.get_json()
    # keyで取得できる
    message = req_data.get('message')
    print(message)
    response = {'message': 'Receive: {}'.format(message)}
    return jsonify(response)


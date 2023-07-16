from flask import jsonify, request
from app import app
import time
import datetime

"""
struct VegeLengthObject {
    var date: String
    var vegeLength: Double
    var x: Double
    var memoText: String
}
"""

# testデータ作成
date = datetime.date(2023, 7, 1)
data_length = 5
date_format = "%Y年%m月%d日%H時"

name_list = ['レタス', 'キャベツ', 'きゅうり', 'なすび']
date_list = []
vegeLength_list = []
x_list = []
memoText_list = []
for i in range(data_length):
    date_list.append(date.strftime(date_format))
    vegeLength_list.append(float(i + 1.5))
    x_list.append(float(i))
    memoText_list.append("")
    date += datetime.timedelta(days = 1)

test_data = []
for i in range(len(name_list)):
    data = {'name': name_list[i],
            'date': date_list,
            'vegeLength': vegeLength_list,
            'x': x_list,
            'memoText': memoText_list
            }
    test_data.append(data)

# GETリクエストに対応するエンドポイント
@app.route('/api/data', methods = ['GET'])
def get_data():
    time.sleep(1)

    return jsonify(test_data)

@app.route('/api/send_data', methods = ['POST'])
def post_data():
    req_data = request.get_json()
    # keyで取得できる
    message = req_data.get('message')
    print(message)
    response = {'message': 'Receive: {}'.format(message)}
    return jsonify(response)


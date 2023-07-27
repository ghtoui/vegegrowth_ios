from flask import jsonify, request
import base64
from app import app
import time
import datetime
import os

# このフォーマットは、swiftで指定したやつに合わせてる
DATE_FORMAT = "%y年%m月%d日 %H時"

# testデータ作成
date = datetime.date(2023, 7, 1)
data_length = 5

static_path = 'app/static/images/'
image_list = ['one_2.jpg', 'two_2.jpg', 'three_2.jpg', 'four_2.jpg', 'five_2.jpg']

name_list = ['レタス', 'キャベツ', 'きゅうり', 'なすび']
date_list = []
vegeLength_list = []
x_list = []
memoText_list = []
encodeimage_list = []
for i in range(data_length):
    date_list.append(date.strftime(DATE_FORMAT))
    vegeLength_list.append(float(i + 1.5))
    x_list.append(float(i))
    memoText_list.append("")
    date += datetime.timedelta(days = 1)
    # 画像をエンコードする
    with open(static_path + image_list[i], 'rb') as file:
        image = file.read()
        image_base64 = base64.b64encode(image).decode('utf-8')
        encodeimage_list.append(image_base64)

test_data = []
for i in range(len(name_list)):
    data = {'name': name_list[i],
            'date': date_list,
            'vegeLength': vegeLength_list,
            'x': x_list,
            'memoText': memoText_list,
            'base64EncodedImage': encodeimage_list
            }
    test_data.append(data)

img_savepath = './app/static/'

# GETリクエストに対応するエンドポイント
@app.route('/api/data', methods = ['GET'])
def get_data():
    time.sleep(1)

    return jsonify(test_data)

@app.route('/api/send_data', methods = ['POST'])
def post_data():
    # テキストデータを受け取る場合は、request.formを使う
    name = request.form.get('name')
    for key, file in request.files.items():
        if file.filename:

            path = os.path.join(img_savepath, str(name), str(file.filename))
            print(os.getcwd())
            print(path)
            path = os.path.join(os.getcwd(), path)
            os.makedirs(path, exist_ok = True)

            file.save(path)


    return "OK"

# base64で受け取るAPI
# 画像を送る場合は、multipart/form-dataを使う方が適切っぽいので、使わないかも
# @app.route('/api/send_data/base64', methods = ['POST'])
# def post_base64_data():
#     req_data = request.get_json()
#     # keyで取得できる
#     name = req_data.get('name')
#     encoded_datas = req_data.get('base64EncodedImage')
#     # base64データを画像データに変換
#     for i, encoded_data in enumerate(encoded_datas):
#         print(encoded_data)
#         img = base64.b64decode(encoded_data)
#         img = np.frombuffer(img, dtype = np.uint8)
#         img = cv.imdecode(img, cv.IMREAD_COLOR)
# 
#         cv.imwrite('gazou{}.jpg'.format(i), img)
# 
#     print(name)
#     # response = {'name': 'Receive: {}'.format(name)}
#     # return jsonify(response)
#     return jsonify({'name': 'ok'})

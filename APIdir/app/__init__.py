from flask import Flask

app = Flask(__name__)

# configfileの読み込み
app.config.from_object('app.config')


# iconの設定
# @app.route('/favicon.ico')
# def favicon():
#     return send_from_directory(os.path.join(app.root_path, 'static/images'), 'favicon.ico', )

@app.route('/', methods = ['GET'])
def hello():
    return 'Hello World'


from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_cloud():
    return 'Hello Aman, Post-deployment is working!!!!'

if __name__ == '__main__':
    app.run(host='0.0.0.0')

from flask import Flask
app = Flask(_name_)

@app.route('/')
def hello_cloud():
  return 'Hello Cloud!'

app.run(host='0.0.0.0')
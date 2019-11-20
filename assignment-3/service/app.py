from flask import Flask
import random
import json

app = Flask(__name__)

counter = 0


@app.route('/')
def index():
    global counter
    counter += 1
    return 'Hey there! You\'re the No. % d caller of this api.' % counter


@app.route('/rand')
def random_value():
    return 'Hey! Your lucky numebr must be %d!' % random.randint(0, 2147483647)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

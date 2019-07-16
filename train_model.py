# https://fasttext.cc/docs/en/python-module.html

import fasttext
model = fasttext.train_unsupervised('data.txt', model='skipgram')
print(model['king'])

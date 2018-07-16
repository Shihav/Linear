import numpy as np
np.set_printoptions(threshold=np.nan)

import newspaper
from nltk.tokenize import sent_tokenize, word_tokenize
from nltk.corpus import stopwords
from string import punctuation
import re


# Code for CNN news crawl and then keeping only the technology ones
url_filter="technology"
site='cnn'
sitefull = "http://" + str(site) + ".com"

cnn_source = newspaper.Source(sitefull,memoize_articles=False)
cnn_source.build()
print(len(cnn_source.articles))
cnn_tech_articles = list(filter(lambda x: url_filter == "" or "/" + url_filter + "/" in x.url,
                                cnn_source.articles))
print(len(cnn_tech_articles))

import xlsxwriter
import datetime

now = datetime.datetime.now()

# Create an new Excel file and add a worksheet.
filename='Data/CNN/' 'Data-' + str(site)+ '-' + str(now.year) + '-' + str(now.month) + '-' + str(now.day) + '.xlsx'
workbook = xlsxwriter.Workbook(filename)
worksheet = workbook.add_worksheet()
worksheet.set_column('A:ID', 20)
worksheet.set_column('B:URL', 20)
worksheet.write(('A' + str(1)), 'URL')
worksheet.write(('B' + str(1)), 'Date')
worksheet.write(('C' + str(1)), 'Title')
worksheet.write(('D' + str(1)), 'Keywords')
worksheet.write(('E' + str(1)), 'Author')
worksheet.write(('F' + str(1)), 'Section')
worksheet.write(('G' + str(1)), 'Description')
worksheet.write(('H' + str(1)), 'Text')
worksheet.write(('I' + str(1)), 'Keys')
worksheet.write(('J' + str(1)), 'Tokens')
worksheet.write(('K' + str(1)), 'Ext Words')
worksheet.write(('L' + str(1)), 'Sig Words')

bold = workbook.add_format({'bold': 1})
cntr=1
for cnn_tech_article in cnn_tech_articles:
    print(cnn_tech_article.url)
    cnn_tech_article.download()
    cnn_tech_article.parse()
    # worksheet.write(('A' + str(cntr)),str(cntr))
    worksheet.write(('A' + str(cntr+1)),cnn_tech_article.url)
    worksheet.write(('B' + str(cntr+1)),str(cnn_tech_article.meta_data['date']))
    worksheet.write(('C' + str(cntr+1)), str(cnn_tech_article.meta_data['title']))
    worksheet.write(('D' + str(cntr+1)), str(cnn_tech_article.meta_data['keywords']))
    worksheet.write(('E' + str(cntr+1)), str(cnn_tech_article.meta_data['author']))
    worksheet.write(('F' + str(cntr+1)), str(cnn_tech_article.meta_data['section']))
    worksheet.write(('G' + str(cntr+1)), str(cnn_tech_article.meta_data['description']))
    worksheet.write(('H' + str(cntr+1)), str(cnn_tech_article.text))
    cnn_tech_article.nlp()
    # print(cnn_tech_article.keywords)
    worksheet.write(('I' + str(cntr + 1)), str(cnn_tech_article.keywords))

    cnn_tech_article.text = re.sub(r'[^\w ]', '', cnn_tech_article.text)
    sents = sent_tokenize(cnn_tech_article.text)
    # print(sents)
    worksheet.write(('J' + str(cntr + 1)), str(sents))
    extracted_words = word_tokenize(cnn_tech_article.text.lower())
    # print(extracted_words)
    worksheet.write(('K' + str(cntr + 1)), str(extracted_words))
    stop_words = set(stopwords.words('english') + list(punctuation) + ['--', '``', "''"])
    significant_words = [w for w in extracted_words if w not in stop_words]
    worksheet.write(('L' + str(cntr + 1)), str(significant_words))
    cntr += 1
workbook.close()

# Code for BBC news crawl and then keeping only the technology ones
url_filter="technology"
site='bbc'
sitefull = "http://" + str(site) + ".com"

cnn_source = newspaper.Source(sitefull,memoize_articles=False)
cnn_source.build()
print(len(cnn_source.articles))
cnn_tech_articles = list(filter(lambda x: url_filter == "" or "/" + url_filter + "-" in x.url,
                                cnn_source.articles))
print(len(cnn_tech_articles))

# Create an new Excel file and add a worksheet.
filename='Data/BBC/' 'Data-' + str(site)+ '-' + str(now.year) + '-' + str(now.month) + '-' + str(now.day) + '.xlsx'
workbook = xlsxwriter.Workbook(filename)
worksheet = workbook.add_worksheet()
worksheet.set_column('A:ID', 20)
worksheet.set_column('B:URL', 20)
worksheet.write(('A' + str(1)), 'URL')
worksheet.write(('B' + str(1)), 'Date')
worksheet.write(('C' + str(1)), 'Title')
worksheet.write(('D' + str(1)), 'Keywords')
worksheet.write(('E' + str(1)), 'Author')
worksheet.write(('F' + str(1)), 'Section')
worksheet.write(('G' + str(1)), 'Description')
worksheet.write(('H' + str(1)), 'Text')
worksheet.write(('I' + str(1)), 'Keys')
worksheet.write(('J' + str(1)), 'Tokens')
worksheet.write(('K' + str(1)), 'Ext Words')
worksheet.write(('L' + str(1)), 'Sig Words')

bold = workbook.add_format({'bold': 1})
cntr=1
for cnn_tech_article in cnn_tech_articles:
    print(cnn_tech_article.url)
    cnn_tech_article.download()
    cnn_tech_article.parse()
    # worksheet.write(('A' + str(cntr)),str(cntr))
    worksheet.write(('A' + str(cntr+1)),cnn_tech_article.url)
    worksheet.write(('B' + str(cntr+1)),str(cnn_tech_article.meta_data['date']))
    worksheet.write(('C' + str(cntr+1)), str(cnn_tech_article.meta_data['title']))
    worksheet.write(('D' + str(cntr+1)), str(cnn_tech_article.meta_data['keywords']))
    worksheet.write(('E' + str(cntr+1)), str(cnn_tech_article.meta_data['author']))
    worksheet.write(('F' + str(cntr+1)), str(cnn_tech_article.meta_data['section']))
    worksheet.write(('G' + str(cntr+1)), str(cnn_tech_article.meta_data['description']))
    worksheet.write(('H' + str(cntr+1)), str(cnn_tech_article.text))
    cnn_tech_article.nlp()
    # print(cnn_tech_article.keywords)
    worksheet.write(('I' + str(cntr + 1)), str(cnn_tech_article.keywords))
    cnn_tech_article.text = re.sub(r'[^\w ]', '', cnn_tech_article.text)
    sents = sent_tokenize(cnn_tech_article.text)
    # print(sents)
    worksheet.write(('J' + str(cntr + 1)), str(sents))
    extracted_words = word_tokenize(cnn_tech_article.text.lower())
    # print(extracted_words)
    worksheet.write(('K' + str(cntr + 1)), str(extracted_words))
    stop_words = set(stopwords.words('english') + list(punctuation) + ['--', '``', "''"])
    significant_words = [w for w in extracted_words if w not in stop_words]
    worksheet.write(('L' + str(cntr + 1)), str(significant_words))
    cntr += 1
workbook.close()

# Code for FOX news crawl and then keeping only the technology ones
url_filter="tech"
site='foxnews'
sitefull = "http://" + str(site) + ".com"

cnn_source = newspaper.Source(sitefull,memoize_articles=False)
cnn_source.build()
print(len(cnn_source.articles))
cnn_tech_articles = list(filter(lambda x: url_filter == "" or "/" + url_filter + "/" in x.url,
                                cnn_source.articles))
print(len(cnn_tech_articles))

# Create an new Excel file and add a worksheet.
filename='Data/FOX/' 'Data-' + str(site)+ '-' + str(now.year) + '-' + str(now.month) + '-' + str(now.day) + '.xlsx'
workbook = xlsxwriter.Workbook(filename)
worksheet = workbook.add_worksheet()
worksheet.set_column('A:ID', 20)
worksheet.set_column('B:URL', 20)
worksheet.write(('A' + str(1)), 'URL')
worksheet.write(('B' + str(1)), 'Date')
worksheet.write(('C' + str(1)), 'Title')
worksheet.write(('D' + str(1)), 'Keywords')
worksheet.write(('E' + str(1)), 'Author')
worksheet.write(('F' + str(1)), 'Section')
worksheet.write(('G' + str(1)), 'Description')
worksheet.write(('H' + str(1)), 'Text')
worksheet.write(('I' + str(1)), 'Keys')
worksheet.write(('J' + str(1)), 'Tokens')
worksheet.write(('K' + str(1)), 'Ext Words')
worksheet.write(('L' + str(1)), 'Sig Words')

bold = workbook.add_format({'bold': 1})
cntr=1
for cnn_tech_article in cnn_tech_articles:
    print(cnn_tech_article.url)
    cnn_tech_article.download()
    cnn_tech_article.parse()
    # worksheet.write(('A' + str(cntr)),str(cntr))
    worksheet.write(('A' + str(cntr+1)),cnn_tech_article.url)
    worksheet.write(('B' + str(cntr+1)),str(cnn_tech_article.meta_data['date']))
    worksheet.write(('C' + str(cntr+1)), str(cnn_tech_article.meta_data['title']))
    worksheet.write(('D' + str(cntr+1)), str(cnn_tech_article.meta_data['keywords']))
    worksheet.write(('E' + str(cntr+1)), str(cnn_tech_article.meta_data['author']))
    worksheet.write(('F' + str(cntr+1)), str(cnn_tech_article.meta_data['section']))
    worksheet.write(('G' + str(cntr+1)), str(cnn_tech_article.meta_data['description']))
    worksheet.write(('H' + str(cntr+1)), str(cnn_tech_article.text))
    cnn_tech_article.nlp()
    # print(cnn_tech_article.keywords)
    worksheet.write(('I' + str(cntr + 1)), str(cnn_tech_article.keywords))
    cnn_tech_article.text = re.sub(r'[^\w ]', '', cnn_tech_article.text)
    sents = sent_tokenize(cnn_tech_article.text)
    # print(sents)
    worksheet.write(('J' + str(cntr + 1)), str(sents))
    extracted_words = word_tokenize(cnn_tech_article.text.lower())
    # print(extracted_words)
    worksheet.write(('K' + str(cntr + 1)), str(extracted_words))
    stop_words = set(stopwords.words('english') + list(punctuation) + ['--', '``', "''"])
    significant_words = [w for w in extracted_words if w not in stop_words]
    worksheet.write(('L' + str(cntr + 1)), str(significant_words))
    cntr += 1
workbook.close()
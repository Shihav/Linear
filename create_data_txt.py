import wikipedia
import re

f = open('data.txt', 'w')
pages = wikipedia.random(50)

for i, page in enumerate(pages):
    print('* %d / %d - %s' % (i+1, len(pages), page))
    try:
        text = wikipedia.page(page).content
        text = re.sub(r'[^a-zA-Z\s]', '', text)  # remove non-alphabetic characters
        text = text.lower()  # put everything in lower-case
        text = text.replace('\n', ' ')  # replace new lines by whitespaces
        f.write(text)
        f.write('\n')
    except:
        pass

#!/usr/bin/env python

import argparse
import requests
import random

class MyQuote:

    def __init__(self):
        self.quotes = []

    def download(self):
        url = 'https://raw.githubusercontent.com/jreisinger/blog/master/posts/quotes.txt'
        r = requests.get(url)
        self.quotes = (r.text)

    def print_rand(self):
        quote = random.choice( self.quotes.split('\n\n') )
        print(quote)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Print a random quote from \
                                        my collection of quotes.')
    args = parser.parse_args()

    quotes = MyQuote()
    quotes.download()
    quotes.print_rand()


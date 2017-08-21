#!/usr/bin/env python3

import argparse
import requests
import random
import time

class MyQuote:

    def __init__(self):
        self.quotes = []

    def download(self):
        url = 'https://raw.githubusercontent.com/jreisinger/blog/master/posts/quotes.txt'
        r = requests.get(url)
        self.quotes = (r.text)

    def print_rand(self, slow):
        quote = random.choice( self.quotes.split('\n\n') )
        if slow:
            self._slow_print(quote)
        else:
            print(quote)

    def _slow_print(self, quote):
        for letter in quote:
            print(letter, end='', flush=True)
            time.sleep(.05)
        print()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Print a random quote from \
                                        my collection of quotes.')
    parser.add_argument('-s', action='store_true', help='print quote slowly')
    args = parser.parse_args()

    quotes = MyQuote()
    quotes.download()
    quotes.print_rand(slow=args.s)


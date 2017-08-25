#!/usr/bin/env python3

import argparse
import requests
import random
import time
import re

class MyQuote:

    def __init__(self):
        self.quotes = []
        self.quote = ''
        self.url = \
         'https://raw.githubusercontent.com/jreisinger/blog/master/posts/quotes.txt'

    def download(self):
        r = requests.get(self.url)
        self.quotes = ( r.text.split('\n\n') )

    def pick(self, regex):
        if regex:
            regex_i = re.compile(regex, re.IGNORECASE)
            quotes = filter( lambda q: re.search(regex_i, q), self.quotes )
            self.quote = '\n\n'.join(quotes)
        else:
            self.quote = random.choice( self.quotes )

    def print_out(self, slow):
        if slow:
            self._slow_print(self.quote)
        else:
            print(self.quote)

    def _slow_print(self, quote):
        for letter in quote:
            print(letter, end='', flush=True)
            time.sleep(.05)
        print()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Print a quote from my \
                                     collection of quotes.')
    parser.add_argument('-s', action='store_true', help='print quote slowly')
    parser.add_argument('-r', metavar='regex', help='print quotes matching \
                        regex (case insensitive)')
    args = parser.parse_args()

    quotes = MyQuote()
    quotes.download()
    quotes.pick(args.r)
    quotes.print_out(args.s)


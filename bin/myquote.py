#!/usr/bin/env python3

import argparse
import requests
import random
import time
import re
import pickle
import os

class MyQuote:

    def __init__(self):
        self.quotes = [] # all quotes
        self.quote = ''  # picked quotes
        self.url = \
         'https://raw.githubusercontent.com/jreisinger/blog/master/posts/quotes.txt'
        self.cache = '/tmp/myquotes.data'

    def get(self):
        """ Read quotes from a local file. If that is too old download them.
        """
        cache_age = os.path.getmtime(self.cache)
        now = time.time()
        day_ago = now - 60*68*24*1
        if cache_age < day_ago: # cache older than a day
            self.download()
        f = open(self.cache, 'rb')
        self.quotes = pickle.load(f)
            
    def download(self):
        """ Download quotes from the Internet.
        """
        r = requests.get(self.url)
        quotes = ( r.text.split('\n\n') )
        f = open(self.cache, 'wb')
        pickle.dump(quotes, f)

    def pick(self, regex):
        """ Pick quotes matching a regex. Or a random quote.
        """
        if regex:
            regex_i = re.compile(regex, re.IGNORECASE)
            quotes = filter( lambda q: re.search(regex_i, q), self.quotes )
            self.quote = '\n\n'.join(quotes)
        else:
            self.quote = random.choice( self.quotes )

    def print_out(self, slow):
        if slow:
            self.slow_print(self.quote)
        else:
            print(self.quote)

    def slow_print(self, quote):
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

    q = MyQuote()
    q.get()
    q.pick(args.r)
    q.print_out(args.s)


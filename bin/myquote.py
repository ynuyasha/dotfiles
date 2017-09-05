#!/usr/bin/env python3

import argparse
import requests
import random
import time
import re
import pickle
import os

class Cache:
    def __init__(self, url, cache_file):
        self.url = url
        self.cache = cache_file
        # Create cache file if it does not exist ...
        try:
            file = open(self.cache, 'r')
        except IOError:
            file = open(self.cache, 'w')
    def get_lines(self):
        """ Return list of quotes from a local file. If that is too old 
            download them from the Web.
        """
        cache_age = os.path.getmtime(self.cache)
        cache_size = os.path.getsize(self.cache)

        now = time.time()
        day_ago = now - 60*68*24*1 

        # cache older than a day or empty
        if cache_age < day_ago or cache_size == 0:
            self._download()

        f = open(self.cache, 'rb')
        self.quotes = pickle.load(f)
        return self.quotes
    def _download(self):
        """ Download quotes from the Web.
        """
        r = requests.get(self.url)
        quotes = ( r.text.split('\n\n') )
        f = open(self.cache, 'wb')
        pickle.dump(quotes, f)

class MyQuote:
    def __init__(self, quotes):
        self.quotes = quotes    # all quotes
        self.quote = ''         # picked quote(s)
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

    url = 'https://raw.githubusercontent.com/jreisinger/blog/master/posts/quotes.txt'
    cache_file = os.path.expanduser('~/.myquotes.data')

    cache = Cache(url, cache_file)
    quotes = MyQuote(cache.get_lines())
    quotes.pick(args.r)
    quotes.print_out(args.s)

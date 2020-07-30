# Sieve of Eratosthenes

from itertools import islice

def odds():
    i = 3
    while True:
        yield i
        i = i + 2

class prime_filter(object):
    def __init__(self, p):
        self.p = p
        self.curr = p

    def __call__(self, x):
        while x > self.curr:
            self.curr += self.p
        return self.curr != x

def sieve():
    yield 2
    iter = odds()
    while True:
        p = next(iter)
        yield p
        iter = filter(prime_filter(p), iter)

# verification
if __name__ == "__main__":
    print(list(islice(sieve(), 100)))
    # or print([iter.next() for i in range(100)])

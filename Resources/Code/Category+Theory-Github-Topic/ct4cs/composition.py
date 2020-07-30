# 2. Implement the composition function in your favorite language.
# It takes two functions as arguments and returns 
# a function that is their composition.
from inspect import signature
from typing import Callable


class Composition:
    def __init__(self, f: Callable, g: Callable):
        self.f = f
        self.g = g

        try:
            self.f_signature = len(list(signature(f).parameters))
        except ValueError:
            # builtins has no signature :<
            self.f_signature = None

    def __call__(self, *args, **kwargs):
        val = self.g(*args, **kwargs)

        if self.f_signature == 0:
            return self.f()
        elif self.f_signature == 1:
            return self.f(val)
        elif self.f_signature:
            return self.f(*val)
        else:
            return self.f(*(val,))


def compose(f: Callable, g: Callable):
    """
    Creates composition of two functions. 
    """
    return Composition(f, g)


if __name__ == '__main__':
    # Test 1
    a = lambda x: x + 2
    b = lambda x: x + 4
    c = compose(a, b)

    v = c(*(0,)) 
    assert v == 6

    print('a(x) = x + 2')
    print('b(x) = x + 4')
    print('c(x) = g(f(x)) , c(0) = ', v)

    print('\n--------------')

    # Test 2
    f = lambda x, y: x + y
    g = lambda x: x + 2
    c = compose(g, f)

    v = c(*(1,2))
    assert v == 5
    print('f(x, y) = x + y')
    print('g(x) = x + 2')
    print('c(x, y) = g(f(x, y)) , c(1,2) = ', v)

    print('\n--------------')

    # Test 3
    v = c(**{'y':1, 'x':2})
    assert v == 5
    print('c(x, y) = g(f(x, y)) , c({y:1, x:2}) = ', v)

    print('\n--------------')

    # Test 4
    from functools import partial

    par_filter = partial(filter, lambda x: x > 12)
    map_filter = compose(par_filter, map)

    xs = list(map_filter(lambda x: x ** 2, [1,2,3,4]))

    assert xs == [16]

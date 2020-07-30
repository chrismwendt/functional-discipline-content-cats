# Define a higher-order function (or a function object) memoize 
# in your favorite language. This function takes a pure function f 
# as an argument and returns a function that behaves almost exactly 
# like f, except that it only calls the original function once for 
# every argument, stores the result internally, and subsequently 
# returns this stored result every time it’s called with the same 
# argument. You can tell the memoized function from the original 
# by watch- ing its performance. For instance, try to memoize a 
# function that takes a long time to evaluate. You’ll have to 
# wait for the result the first time you call it, but on subsequent 
# calls, with the same argument, you should get the result immediately.

class Memoize:
    def __init__(self, f):
        self.f = f
        self._values = dict()

    def _set_value_(self, *args, **kwargs):
        if args:
            value = self.f(*args)
            self._values[str(args)] = value
            return value

        value = self.f(**kwargs)
        self._values[str(kwargs)] = value
        return value

    def _get_value_(self, *args, **kwargs):
        if args:
            return self._values.get(str(args))

        return self._values.get(str(kwargs))

    def __call__(self, *args, **kwargs):
        mem_value = self._get_value_(*args, **kwargs)
        if mem_value:
            return mem_value

        return self._set_value_(*args, **kwargs)


if __name__ == '__main__':
    from time import sleep, time

    def printtime(f, *args, **kwargs):
        tic = time()
        v = f(*args, **kwargs)
        toc = time()
        print(v, f'Exe time : {toc-tic}')

    def test(n: int):
        sleep(1)
        return n

    memtest = Memoize(test)

    printtime(test, 1)
    printtime(memtest, 1)

    printtime(test, 1)
    printtime(memtest, 1)

    printtime(memtest, **{'n':2})
    printtime(memtest, 3)

    print(memtest._values)

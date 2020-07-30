from random import *
from itertools import permutations

# Given any permutation, turn it into disjoint k-cycles
# input a is a n length permutation e.g. [2, 4, 1, 3, 5, 7, 6]
# output a list of k-cycles, e.g. [[1, 2, 4, 3], [6, 7]]
def kcycles(a):
    r = []
    n = len(a)
    for i in range(n):
        p = []
        while i + 1 != a[i]:
            p.append(a[i])
            j = a[i] - 1
            a[i], a[j] = a[j], a[i]
        if p != []:
            r.append([a[i]] + p)
    return r if r != [] else [[1]]

# Produce the permutation from a list of disjoint k-cycles.
# input the k-cycle list and the length of the permutation.
# output the permutation list.
def permute(ps, n):
    a = list(range(1, n + 1))
    for p in ps:
        j = p[0]
        for i in p[1:]:
            a[j - 1] = i
            j = i
        a[p[-1] - 1] = p[0]
    return a

def test():
    for _ in range(100):
        a = list(range(1, randint(2, 100)))
        shuffle(a)
        ps = kcycles(a[:])
        b = permute(ps, len(a))
        if a != b:
            print("permutation:", a)
            print("k-cycles:", ps)
            print("restore:", b)
            exit()
    print("100 tests pass")

# Enumerate all elements for a given Symmetry group Sn
def senum(n):
    return [kcycles(list(p)) for p in permutations(range(1, n + 1))]

if __name__ == "__main__":
    test()
    print("examples of S3, S4")
    print("S3:", senum(3))
    print("S4:", senum(4))

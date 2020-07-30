from random import randint
# Eliminate recursion in Euclidean algorithm

def gcm(a, b):
    while b != 0:
        a, b = (b, a % b)
    return a

#
# Extended Euclidean algorithm
# r0 = a, r1 = b
# s0 = 1, s1 = 0
# t0 = 0, t1 = 1
# ...    ...
# r_{i+1} = r_{i-1} - q_{i} * r_{i},   q_{i} = r_{i} // r_{i-1}
# s_{i+1} = s_{i-1} - q_{i} * s_{i}
# t_{i+1} = t_{i-1} - q_{i} * t_{i}
#
# when r_{k+1} == 0
#    gcm(a, b) = gcm(r_{k-1}, r_{k}) = gcm(r_k, 0) = r_{k}
#    Bezout identity: gcm(a, b) = r_{k} = a * s_{k} + b * t_{k}
#
# Proof: induction
#   0: r0 = a == a * s0 + b * t0 = a * 1 + b * 0 = a
#   1: r1 = b == a * s1 + b * t1 = a * 0 + b * 1 = b
#
#   suppose i hold: r_{i} = a * s_{i} + b * t_{i}, so as i - 1
#   i + 1:
#     r_{i+1} = r_{i-1} - q_{i} * r_{i}   -- definition
#             = (a * s_{i-1} + b * t_{i-1}) - q_{i} * (a * s_{i} + b * t_{i}) -- assumption
#             = a * (s_{i-1} - q_{i} * s_{i}) + b * (t_{i-1} - q_{i} * t_{i})
#             = a * s_{i+1} + b * t_{i+1}  -- definition

def gcmex(a, b):
    s, olds = (0, 1)
    t, oldt = (1, 0)
    while b != 0:
        q, r = (a // b, a % b)
        s, olds = (olds - q * s, s)
        t, oldt = (oldt - q * t, t)
        a, b = (b, r)
    return (a, olds, oldt)

def testgcm():
    for _ in range(100):
        a = randint(1, 100)
        b = randint(1, 100)
        a, b = (max(a, b), min(a, b))
        g = gcm(a, b)
        d, x, y = gcmex(a, b)
        if g != d or d != a * x + b * y:
            print("err: a = {%d}, b = {%d}, g = {%d}, d = {%d}, x = {%d}, y = {%d}" %
                  (a, b, g, d, x, y))
    print("gcm tested")

def gmod(a, b):
    while b < a:
        a = a - b
    return a

def fastmod(a, b):
    if a < b:
        return a
    c = b
    while a - c >= c:
        c = c + c     # double c to the largest
    a = a - c
    while c != b and abs(c - b) > 1e-5:
        c = c // 2    # how to implement this without div ?
        if c <= a:
            a = a - c
    return a

def modfibonacci(a, b):
    if a < b:
        return a
    c = b
    while c <= a:
        c, b = (b + c, c)   # increase c in Fibonacci manner
    while b != c and abs(c - b) > 1e-5:
        c, b = (b, c - b)   # decrease c back
        if c <= a :
            a = a - c
    return a

def testmod():
    for _ in range(100):
        a = randint(1, 100)
        b = randint(1, 100)
        a, b = (max(a, b), min(a, b))
        c = a % b
        d = fastmod(a, b)
        e = modfibonacci(a, b)
        if c != d or c != e:
            print("err: a = {%d}, b={%d}, c = {%d}, d = {%d}, e={%d}" % (a, b, c, d, e))
    print("fast mod tested")

if __name__ == "__main__":
    testgcm()
    testmod()

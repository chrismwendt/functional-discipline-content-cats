# Find the longest sub-string without repeated chars

# solution 1: map of char to its last occurrence position.

def longestnub(str):
    pos = {}
    maxlen = 0
    start_max = 0
    start_cur = 0
    for i in range(len(str)):
        if str[i] in pos:
            j = pos[str[i]]
            start_cur = max(start_cur, j + 1)
        if i - start_cur + 1 > maxlen:
            start_max = start_cur
        maxlen = max(maxlen, i - start_cur + 1)
        pos[str[i]] = i
    return str[start_max : start_max + maxlen]

# solution 2: map char to prime

# For simplification purpose, use 52 primes for a..z A..Z, see chapter 6
# for infinite stream of primes

PRIMES = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53,
          59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113,
          127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181,
          191, 193, 197, 199, 211, 223, 227, 229, 233, 239]

def primeof(c):
    return PRIMES[ord(c) - ord('a')]

def longestnub_nt(str):
    maxlen = 0
    start_max = 0
    start_cur = 0
    fp = 1            # number theory finger print
    for i in range(len(str)):
        p = primeof(str[i])
        if (fp % p) == 0:
            while str[start_cur] != str[i]:
                fp = fp / primeof(str[start_cur])
                start_cur += 1
            start_cur += 1
        fp *= p
        if i - start_cur + 1 > maxlen:
            start_max = start_cur
        maxlen = max(maxlen, i - start_cur + 1)
    return str[start_max : start_max + maxlen]

# verification
TEST = ["abcdefg", "aaaaaaa", "abcabcbb"]

for s in TEST:
    a = longestnub(s)
    b = longestnub_nt(s)
    print("longestnub(", s, ")=", a, "longestnub_nt(", s, ")=", b,
          "OK:", a == b)

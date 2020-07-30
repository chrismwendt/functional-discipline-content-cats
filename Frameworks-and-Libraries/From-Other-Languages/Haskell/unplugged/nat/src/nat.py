# Find the longest sub-string without repeated chars

def longestNub(str):
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

print("abcdefg ==> ", longestNub("abcdefg"))
print("aaaaaaa ==> ", longestNub("aaaaaaa"))
print("abcabcbb ==> ", longestNub("abcabcbb"))

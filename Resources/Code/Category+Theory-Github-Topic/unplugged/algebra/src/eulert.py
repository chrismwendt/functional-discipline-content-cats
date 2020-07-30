# Euler's totient function

def eulert(n):
    phi = [1] * (n + 1)
    sieve = list(range(2, n + 1))
    while sieve:
        p = sieve[0]
        sieve = list(filter(lambda x : x % p != 0, sieve[1:]))
        power = p
        while power <= n:
            for i in range(power, n + 1, power):
                phi[i] *=  (p - 1) if power == p else p
            power *= p
    return phi

# brute-force method for verification
def gcd(a, b):
    while b != 0:
        a, b = (b, a % b)
    return a

def euler_phi(n):
    return len([i for i in range(1, n) if gcd(i, n) == 1])

# verification
if __name__ == "__main__":
    n = 100
    a = eulert(n)
    b = [euler_phi(i) for i in range(2, n + 1)]
    print("Euler's totient table [2-100]:", a)
    print("Generate from definition :", b)
    for i in range(2, n + 1):
        if a[i] != b[i-2]:
            print("err: i=", i, "a=", a[i], "b=", b[i-2])

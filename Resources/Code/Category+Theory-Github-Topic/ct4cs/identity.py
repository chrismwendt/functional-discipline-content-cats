# 1. Implement, as best as you can, the identity function in 
# your favorite language (or the second favorite, if your favorite 
# language happens to be Haskell).
identity = lambda x: x



# 3. Write a program that tries to test that your composition 
# function respects identity.
from composition import compose
def compose_identity():
    f = lambda x: x * 2

    assert compose(f, identity)(2) == f(2)
    assert compose(identity, f)(3) == f(3)

    f = lambda x, y: x * y

    assert compose(f, identity)((2, 5)) == f(2, 5), "idR does not work"
    assert compose(identity, f)(*(2, 5)) == f(2, 5), "idL does not work"

    print('Left and right identity works!')


if __name__ == '__main__':
    # Test identity
    t = lambda x : x + 2
    print('Identity : ', identity(t) == t)

    # Try with args
    identity(t)(*(2,))

    # check
    compose_identity()

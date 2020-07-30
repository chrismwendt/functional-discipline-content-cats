// f :: A -> B
B f(A a);
// g :: B -> C
C g(B b);

// Composition (g . f) :: A -> C
C g_f(A a)
{
    return g(f(a));
}

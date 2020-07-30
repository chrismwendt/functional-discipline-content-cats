/**
 * @file    main.cpp
 * @author  isnullxbh
 * @date    27/08/2019 15:35
 * @version 0.1.0
 */

#include <functional>
#include <iostream>
#include <cassert>

class A {};
class B {};
class C {};
class D {};

template<typename T1, typename ...Ts, typename T2>
std::function<T2(Ts...)> compose(std::function<T2(T1)> g, std::function<T1(Ts...)> f)
{
    return [=](Ts&&... args) { return g(f(args...)); };
}

template<typename T1, typename ...Ts, typename I>
std::function<T1(Ts...)> compose(std::function<T1(Ts...)> f, I i)
{
    return [=](Ts&&... args) { return f(i(args...)); };
}

template<typename T1, typename ...Ts, typename I>
std::function<T1(Ts...)> compose(I i, std::function<T1(Ts...)> f)
{
    return [=](Ts&&... args) { return i(f(args...)); };
}

template<typename T1, typename ...Ts, typename T2>
decltype(auto) operator<<(std::function<T2(T1)> g, std::function<T1(Ts...)> f)
{
    return compose(g, f);
}

template<typename T1, typename ...Ts, typename I>
decltype(auto) operator<<(std::function<T1(Ts...)> f, I i)
{
    return compose(f, i);
}

template<typename T1, typename ...Ts, typename I>
decltype(auto) operator<<(I i, std::function<T1(Ts...)> f)
{
    return compose(i, f);
}

template<typename T1, typename ...Ts>
std::function<T1(Ts...)> make_function(T1(*fp)(Ts...)) { return fp; }

B atob(A) { return B(); }
C btoc(B) { return C(); }
D ctod(C) { return D(); }

template<typename ...Ts>
void print(Ts ...args)
{
    ((std::cout << args << ", "), ...);
}

auto identity = [](auto&& arg) -> decltype(auto) { return static_cast<decltype(arg)>(arg); };

int main()
{
    auto atod_1 = make_function(ctod) << (make_function(btoc) << make_function(atob));
    auto atod_2 = (make_function(ctod) << make_function(btoc)) << make_function(atob);
    auto atod_3 = make_function(ctod) << make_function(btoc) << make_function(atob);

    assert(typeid(atod_1(A())) == typeid(D));
    assert(typeid(atod_2(A())) == typeid(D));
    assert(typeid(atod_3(A())) == typeid(D));

    auto atob_1 = make_function(atob) << identity;
    auto atob_2 = identity << make_function(atob);

    assert(typeid(atob_1(A())) == typeid(B));
    assert(typeid(atob_2(A())) == typeid(B));

    auto f1 = compose(make_function(btoc), make_function(atob));
    auto f2 = make_function(btoc) << make_function(atob);

    print(typeid(f1).name(), typeid(f2).name());
}

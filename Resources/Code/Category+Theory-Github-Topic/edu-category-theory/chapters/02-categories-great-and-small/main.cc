/**
 * @file    main.cc
 * @author  isnullxbh
 * @date    29/08/2019 23:23
 * @version 0.1.0
 */

#include <string>
#include <iostream>

template<typename T>
T mempty() = delete;

template<typename T>
T mappend(T, T) = delete;

template<typename T>
concept bool Monoid = requires (T t)
{
    { mempty<T>() } -> T;
    { mappend(t, t) } -> T;
};

template<>
int mempty() { return 0; }

template<>
int mappend(int l, int r) { return l + r; }

template<typename F, typename T>
decltype(auto) foldl(F, T arg) { return arg; }

template<typename F, typename T, typename ...Ts>
decltype(auto) foldl(F f, T init, T head, Ts ...tail)
{
    return foldl(f, f(init, head), tail...);
}

template<typename F, typename T>
decltype(auto) foldr(F, T arg) { return arg; }

template<typename F, typename T, typename ...Ts>
decltype(auto) foldr(F f, T init, T head, Ts ...tail)
{
    return f(head, foldr(f, init, tail...));
}

template<Monoid T, typename ...Ts>
decltype(auto) mconcat(T head, Ts ...tail)
{
    return foldr(&mappend<T>, mempty<T>(), head, tail...);
}

int main()
{
    auto sum = [](auto l, auto r) -> decltype(auto) { return (l + r); };

    std::cout << foldl(sum, 10, 20, 30, 40) << std::endl;

    std::cout << foldr(sum, 10, 20, 30, 40) << std::endl;

    std::cout << mconcat(10, 20, 30, 40) << std::endl;
}

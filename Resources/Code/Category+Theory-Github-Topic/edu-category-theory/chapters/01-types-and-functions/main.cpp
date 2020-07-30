/**
 * @file    main.cpp
 * @author  isnullxbh
 * @date    27/08/2019 18:51
 * @version 0.1.0
 */

#include <functional>
#include <unordered_map>
#include <random>

enum Boolean { True, False, Bottom };

// Q: Сколько имеется различных функций от Bool к Bool?
// A: https://stackoverflow.com/questions/18716804/27-different-bool-to-bool-values-in-haskell

template<typename Ret, typename Arg>
std::function<Ret(Arg)> memoize(std::function<Ret(Arg)> f)
{
    using map_t = std::unordered_map<Arg, Ret>;
    return [f = std::move(f)](Arg arg)
        {
            static map_t map;
            if (map.contains(arg))
                return map[arg];
            const auto ret = f(arg);
            map[arg] = ret;
            return ret;
        };
}

template<typename Ret>
std::function<Ret(void)> memoize(std::function<Ret(void)> f)
{
    return [f = std::move(f)]()
    {
        static const auto ret = f();
        return ret;
    };
}

int div2(int arg) { return arg/2; }

int main()
{
    auto memoize_div2 = memoize(std::function<int(int)>(div2));
    memoize_div2(1);
    memoize_div2(2);
    memoize_div2(2);
    memoize_div2(1);

    auto memoize_rand = memoize(std::function<int(void)>(std::rand));
    memoize_rand();
    memoize_rand();
    memoize_rand();
}

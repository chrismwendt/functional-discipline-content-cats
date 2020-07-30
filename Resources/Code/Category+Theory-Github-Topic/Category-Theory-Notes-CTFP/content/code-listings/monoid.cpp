template<class T>
T mempty = delete;

template<class T>
T mappend(T, T) = delete;

template<class M>
concept bool Monoid = requires (M m) {
    { mempty<M> } -> M;
    { mappend(m, m); } -> M;
};

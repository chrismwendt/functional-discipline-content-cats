const compose = (f, g) => {
    return x => g(f(x));    
};

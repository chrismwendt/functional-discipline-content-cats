type Writer<T> = [T, string];

function composeW<T, U, R>(
    w1: Writer<T>, w2: Writer<U>): Writer<R> {
    return (value: R) => {
        const [intermediate, logW1] = w1(value);
        const [result, logW2] = w2(intermediate);
        return [result, logW1 + logW2];
    };
}

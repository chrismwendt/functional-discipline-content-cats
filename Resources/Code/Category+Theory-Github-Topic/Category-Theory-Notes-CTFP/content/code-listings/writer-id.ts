function identity<A>(value: A): Writer<A> {
    return [value, ""];
}

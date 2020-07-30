trait Functor<A, B, F: Fn(A) -> B> {
    type Output;
    fn fmap(self, f: F) -> Self::Output;
}

use std::marker::PhantomData;

#[derive(Debug)]
struct Const<B>(B, PhantomData<B>);

impl<A, B, F: Fn(A) -> B> Functor<A, B, F> for Const<A> {
    type Output = Const<A>;
    fn fmap(self, _f: F) -> Const<A> {
        self
    }
}

#[derive(Debug)]
struct Identity<A>(A);

impl<A, B, F: Fn(A) -> B> Functor<A, B, F> for Identity<A> {
    type Output = Identity<B>;
    fn fmap(self, f: F) -> Identity<B> {
        Identity(f(self.0))
    }
}

type List<T> = Vec<T>;

impl<A, B, F: Fn(A) -> B> Functor<A, B, F> for List<A> {
    type Output = List<B>;
    fn fmap(self, f: F) -> List<B> {
        let mut list_b: List<B> = List::new();
        for item in self {
            list_b.push(f(item));
        }
        list_b
    }
}

#[derive(Debug)]
enum Maybe<T> {
    Nothing,
    Just(T),
}

use Maybe::*;

impl<A, B, F: Fn(A) -> B> Functor<A, B, F> for Maybe<A> {
    type Output = Maybe<B>;
    fn fmap(self, f: F) -> Maybe<B> {
        match self {
            Nothing => Nothing,
            Just(a) => Just(f(a)),
        }
    }
}

#[derive(Debug)]
struct Writer<A> {
    value: A,
    log: String,
}

impl<A, B, F: Fn(A) -> B> Functor<A, B, F> for Writer<A> {
    type Output = Writer<B>;
    fn fmap(self, f: F) -> Writer<B> {
        Writer { value: f(self.value), log: self.log }
    }
}

fn compose<A, B, C, F: Fn(A) -> B, G: Fn(B) -> C>(f: F, g: G) -> impl Fn(A) -> C {
    move |a| g(f(a))
}

struct Reader<R, A>(Box<Fn(R) -> A>);

impl<R: 'static, A: 'static, B: 'static, F: 'static + Fn(A) -> B> Functor<A, B, F> for Reader<R, A> {
    type Output = Reader<R, B>;
    fn fmap(self, f: F) -> Reader<R, B> {
        Reader(Box::new(compose(self.0, f)))
    }
}

fn main() {
    let c = Const(2, PhantomData);
    println!("{:?}", c.fmap(|_a| ())); // Const(2, PhantomData)
    
    let i = Identity(2);
    println!("{:?}", i.fmap(|a| a + 2)); // Identity(4)
    
    let l = vec![1, 2, 3, 4];
    println!("{:?}", l.fmap(|a| a + 2)); // [3, 4, 5, 6] 
    
    let m = Just(5);
    println!("{:?}", m.fmap(|a| a + 2)); // Just(7)
    
    let w = Writer { value: 10, log: "dez".to_string() };
    println!("{:?}", w.fmap(|a| a * 5)); // Writer { value: 50, log: "dez" }
    
    let r = Reader(Box::new(|r| format!("r: {}", r)));
    println!("{:?}", r.fmap(|a| format!("a: ({})", a)).0(2)); // "a: (r: 2)"

    // poderia printar a estrutura Reader, mas para printar uma
    // função na tela precisa de muito código boilerplate
    // decidi não implementar para não confundir mais
}

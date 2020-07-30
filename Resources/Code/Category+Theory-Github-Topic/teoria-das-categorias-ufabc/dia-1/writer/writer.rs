#[derive(Debug)]
struct Writer<A> {
    value: A,
    log: String,
}

impl<A> Writer<A> {
    fn new(value: A, log: Option<String>) -> Self {
        Writer {
            value,
            log: log.unwrap_or(String::new())
        }
    }
    fn bind<B, F: Fn(A) -> Writer<B>>(self, f: F) -> Writer<B> {
        let y = f(self.value);
        Writer::new(y.value, Some(format!("{}{}", self.log, y.log)))
    }
}

fn fish<A, B, C, F: Fn(A) -> Writer<B>, G: Fn(B) -> Writer<C>>(f: F, g: G) -> impl Fn(A) -> Writer<C> {
    move |a| {
        let writer_ab = f(a);
        let writer_bc = g(writer_ab.value);
        Writer::new(writer_bc.value, Some(format!("{}{}", writer_ab.log, writer_bc.log)))
    }
}

fn main() {
    let writer = Writer::new(3, Some("tres".to_string()));
    
    println!("Writer::new() = {:?}", writer); // Writer::new() = Writer { value: 3, log: "tres" }
    println!("bind() = {:?}", writer.bind(|a| Writer::new(a + 2, Some(" mais dois".to_string())))); // Writer::new() = Writer { value: 3, log: "tres" }
    
    let f = |a| Writer::new(a + 3, Some("mais tres".to_string()));
    let g = |b| Writer::new(b + 5, Some(" mais cinco".to_string()));
    println!("fish() = {:?}", fish(f, g)(1)); // Writer { value: 9, log: "mais tres mais cinco" }
}

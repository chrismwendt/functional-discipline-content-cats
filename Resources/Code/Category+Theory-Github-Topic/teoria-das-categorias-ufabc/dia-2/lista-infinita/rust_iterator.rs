struct LazyList {
    current: u64,
}

impl Iterator for LazyList {
    type Item = u64;
    fn next(&mut self) -> Option<u64> {
        let item = self.current;
        self.current += 1;
        Some(item)
    }
}

fn main() {
    let lazy_list = LazyList { current: 0 };
    
    for item in lazy_list.take(15) { // só irá chamar `next` 15 vezes
        println!("item: {}", item);
    }
    
    let example_list: Vec<u64> = LazyList { current: 0 }.take(3).collect(); // só irá chamar `next` 3 vezes
    
    println!("example_list: {:?}", example_list); // [0, 1, 2]
}

// similar ao Iterator do Rust, mas mais simples e menos flexível
trait MyIterator {
    type Item;
    fn next(&mut self) -> Option<Self::Item>;
    fn take(&mut self, quantity: u64) -> Vec<Self::Item> {
        let mut list = vec![];
        for _i in 0..quantity {
            list.push(self.next().unwrap());
        }
        list
    }
}

struct LazyList {
    current: u64,
}

impl MyIterator for LazyList {
    type Item = u64;
    fn next(&mut self) -> Option<u64> {
        let item = self.current;
        self.current += 1;
        Some(item)
    }
}

fn main() {
    let mut lazy_list = LazyList { current: 0 };
    
    for item in lazy_list.take(15) { // só irá chamar `next` 15 vezes
        println!("item: {}", item);
    }
    
    let example_list = LazyList { current: 0 }.take(3); // só irá chamar `next` 3 vezes
    
    println!("example_list: {:?}", example_list); // [0, 1, 2]
}

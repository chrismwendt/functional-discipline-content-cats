#[derive(Debug)]
struct Zipper<T> {
    left: Vec<T>,
    right: Vec<T>,
}

fn cria_zip<T>(list: Vec<T>) -> Zipper<T> {
    Zipper {
        left: Vec::new(),
        right: list,
    }
}

fn esq<T>(mut zipper: Zipper<T>) -> Zipper<T> {
    if zipper.left.is_empty() {
        return zipper;
    }
    
    zipper.right.insert(0, zipper.left.remove(0));
    
    zipper
}

fn dir<T>(mut zipper: Zipper<T>) -> Zipper<T> {
    if zipper.right.is_empty() {
        return zipper;
    }
    
    zipper.left.insert(0, zipper.right.remove(0));
    
    zipper
}

fn main() {
    let zip = cria_zip(vec![1,2,3]);
    println!("estado inicial: {:?}", zip); // Zipper { left: [], right: [1, 2, 3] }
    
    let zip = dir(zip);
    println!("x1 dir: {:?}", zip); // Zipper { left: [1], right: [2, 3] }
    
    let zip = dir(zip);
    println!("x2 dir: {:?}", zip); // Zipper { left: [2, 1], right: [3] }
    
    let zip = esq(zip);
    println!("x2 dir + x1 esq: {:?}", zip); // Zipper { left: [1], right: [2, 3] }
}

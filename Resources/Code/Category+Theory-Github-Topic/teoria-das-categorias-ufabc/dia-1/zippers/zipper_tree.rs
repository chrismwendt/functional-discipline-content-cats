#[derive(Debug)]
enum Either<L, R> {
    Left(L),
    Right(R),
}

use Either::*;

#[derive(Debug)]
enum Tree<T> {
    Empty,
    Node(Box<Tree<T>>, T, Box<Tree<T>>),
}

use Tree::*;

#[derive(Debug)]
struct Zipper<T> {
    left: Tree<T>,
    right: Tree<T>,
    focus: Vec<Either<(T, Tree<T>), (T, Tree<T>)>>,
}

fn cria_zip<T>(tree: Tree<T>) -> Zipper<T> {
    match tree {
        Empty => Zipper { left: Empty, right: Empty, focus: vec![] },
        Node(left, x, right) => Zipper {
            left: *left,
            right: *right,
            focus: vec![Left((x, Empty))],
        },
    }
}

fn esq<T>(mut zipper: Zipper<T>) -> Zipper<T> {
    match zipper.left {
        Empty => zipper,
        Node(left, x, right) => {
            zipper.focus.insert(0, Left((x, zipper.right)));
            
            Zipper {
                left: *left,
                right: *right,
                focus: zipper.focus,
            }
        },
    }
}

fn dir<T>(mut zipper: Zipper<T>) -> Zipper<T> {
    match zipper.right {
        Empty => zipper,
        Node(left, x, right) => {
            zipper.focus.insert(0, Right((x, zipper.left)));
            
            Zipper {
                left: *left,
                right: *right,
                focus: zipper.focus,
            }
        },
    }
}

fn upwards<T>(mut zipper: Zipper<T>) -> Zipper<T> {
    if zipper.focus.is_empty() || zipper.focus.len() == 1 {
        return zipper;
    }
    
    let head_focus = zipper.focus.remove(0);
    let tail_focus = zipper.focus;
    
    match head_focus {
        Left((x, tree)) => Zipper {
            left: Node(Box::new(zipper.left), x, Box::new(zipper.right)),
            right: tree,
            focus: tail_focus,
        },
        Right((x, tree)) => Zipper {
            left: tree,
            right: Node(Box::new(zipper.left), x, Box::new(zipper.right)),
            focus: tail_focus,
        },
    }
}

fn main() {
    //   2
    //  /\ 
    // 4 5
    let left_node = Box::new(Node(
        Box::new(Node(Box::new(Empty), 4, Box::new(Empty))),
        2,
        Box::new(Node(Box::new(Empty), 5, Box::new(Empty)))
    ));
    
    //   3
    //  /\ 
    // 6 7
    let right_node = Box::new(Node(
        Box::new(Node(Box::new(Empty), 6, Box::new(Empty))),
        3,
        Box::new(Node(Box::new(Empty), 7, Box::new(Empty)))
    ));
    
    //    1
    //   / \
    //   2 3
    //  /\ /\
    // 4 5 6 7
    let zip = cria_zip(Node(left_node, 1, right_node));
    println!("estado inicial: {:?}", zip);
    
    // Zipper {
    //   left: Node(
    //      Node(Empty, 4, Empty),
    //      2,
    //      Node(Empty, 5, Empty)
    //   ),
    //   right: Node(
    //      Node(Empty, 6, Empty),
    //      3,
    //      Node(Empty, 7, Empty)
    //   ),
    //   focus: [
    //     Left((1, Empty))
    //   ]
    // }
    
    let zip = dir(zip);
    println!("x1 dir: {:?}", zip);
    
    // Zipper {
    //   left: Node(Empty, 6, Empty),
    //   right: Node(Empty, 7, Empty),
    //   focus: [
    //     Right(
    //       3,
    //       Node(
    //         Node(Empty, 4, Empty),
    //         2,
    //         Node(Empty, 5, Empty)
    //       )
    //     ),
    //     Left((1, Empty))
    //   ]
    // }
    
    let zip = esq(zip);
    println!("x1 dir + x1 esq: {:?}", zip);
    
    // Zipper {
    //   left: Empty,
    //   right: Empty,
    //   focus: [
    //     Left(
    //       6,
    //       Node(Empty, 7, Empty),
    //     ),
    //     Right(
    //       3,
    //       Node(
    //         Node(Empty, 4, Empty),
    //         2,
    //         Node(Empty, 5, Empty)
    //       )
    //     ),
    //     Left((1, Empty))
    //   ]
    // }
    
    let zip = upwards(zip);
    println!("x1 dir + x1 esq + x1 upwards: {:?}", zip);
    
    // Zipper {
    //   left: Node(Empty, 6, Empty),
    //   right: Node(Empty, 7, Empty),
    //   focus: [
    //     Right(
    //       3,
    //       Node(
    //         Node(Empty, 4, Empty),
    //         2,
    //         Node(Empty, 5, Empty)
    //       )
    //     ),
    //     Left((1, Empty))
    //   ]
    // }
}

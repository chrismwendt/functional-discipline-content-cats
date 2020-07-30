// O derive Debug é apenas para poder printar Either na tela
// Como se fosse um deriving da type class Show
#[derive(Debug)]
enum Either<L, R> {
  Left(L),
  Right(R),
}

fn safe_div(x: isize, y: isize) -> Either<(), isize> {
    // Serve apenas para não precisar usar Either::Left ou Either::Right
    use Either::*;
    
    match (x, y) {
        (_x, 0) => Left(()),
        (x, y) => Right(x / y)
    }
}

type Maybe<T> = Either<(), T>;

fn safe_sqrt(x: f64) -> Maybe<f64> {
    use Either::*;

    if x < 0.0 {
        Left(())
    } else {
        Right(x.sqrt())
    }
}

fn main() {
    println!("safe_div(1, 2): {:?}", safe_div(1, 2)); // Right(0)
    println!("safe_div(1, 0): {:?}", safe_div(1, 0)); // Left(())

    println!("safe_sqrt(144.0): {:?}", safe_sqrt(144.0)); // Right(12.0)
    println!("safe_sqrt(-1.0): {:?}", safe_sqrt(-1.0)); // Left(())
}

import Bow

public func isEqual<F: EquatableK & Functor>(
    _ fa: Kind<F, Void>,
    _ fb: Kind<F, Void>) -> Bool {
    fa.map { 0 } == fb.map { 0 }
}

public func isEqual<F: EquatableK & Functor, A: Equatable, B: Equatable>(
    _ fa: Kind<F, (A, B)>,
    _ fb: Kind<F, (A, B)>) -> Bool {
    
    fa.map { x in x.0 } == fb.map { y in y.0 } &&
    fa.map { x in x.1 } == fb.map { y in y.1 }
}

public func isEqual<F: EquatableK & Functor, A: Equatable, B: Equatable, C: Equatable>(
    _ fa: Kind<F, ((A, B), C)>,
    _ fb: Kind<F, (A, (B, C))>) -> Bool {
    fa.map { x in x.0 }.map { xx in xx.0 } == fb.map { y in y.0 } &&
    fa.map { x in x.0 }.map { xx in xx.1 } == fb.map { y in y.1 }.map { yy in yy.0 } &&
    fa.map { x in x.1 } == fb.map { y in y.1 }.map { yy in yy.1 }
}

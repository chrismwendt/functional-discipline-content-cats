struct Person {
    age: usize,
}

struct Employee {
    person: Person,
}

fn sort_age(i: usize, j: usize) -> bool {
    i < j
}

fn get_age(person: Person) -> usize {
    person.age
}

fn get_person(employee: Employee) -> Person {
    employee.person
}

fn compose<A, B, C, F: Fn(A) -> B, G: Fn(B) -> C>(f: F, g: G) -> impl Fn(A) -> C {
    move |a| g(f(a))
}

fn contramap<A, B, F: Fn(A, A) -> bool, G: Fn(B) -> A>(f: F, g: G) -> impl Fn(B, B) -> bool {
    move |x: B, y: B| f(g(x), g(y))
}

fn main() {
    let sort_employee = contramap(sort_age, compose(get_person, get_age));
    
    let employee_a = Employee { person: Person { age: 40 } };
    
    let employee_b = Employee { person: Person { age: 50 } };
    
    let result = sort_employee(employee_a, employee_b);
    
    println!("result: {}", result); // true

    // Não vejo taanta vantagem assim de fazer dessa forma, acredito ser só mais uma maneira.
    // o que sei é que usando a biblioteca padrão, seria melhor e mais idiomático implementar
    // a trait (interface) `Ordering`
    // Consigo ver mais vantagem fazer isso em uma linguagem com mais suporte a programação
    // funcional
}

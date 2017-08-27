fn main(){
    for x in 0..10{
        println!("{}", fib(x));
    }
}

fn fib(num :i32) -> i32{
    if num <= 1 {
        num
    }else{
        fib(num-2) + fib(num-1)
    }
}

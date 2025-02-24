// Include the same things as wrapper-consumer, but in a different package.
// That way we can ensure dependencies are resolved without looping
// infinitely.
module second_package::main2 {
    use wrapper::one::{create_one, One};
    use wrapper::five::{create_wrapper_five, WrapperFive};
    use wrapper_consumer::main::{create_consumer as cc2, Consumer as C2};
    
    struct Consumer has copy, drop, store {
        one: One,
        five: WrapperFive,
    }
    
    #[view]
    public fun create_consumer(): (Consumer, C2) {
        (
            Consumer {
                one: create_one(),
                five: create_wrapper_five(),
            },
            cc2()
        )
    }
}


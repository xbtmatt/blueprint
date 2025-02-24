module wrapper_consumer::main {
    use wrapper::one::{create_one, One};
    use wrapper::five::{create_wrapper_five, WrapperFive};
    
    struct Consumer has copy, drop, store {
        one: One,
        five: WrapperFive,
    }
    
    #[view]
    public fun create_consumer(): Consumer {
        Consumer {
            one: create_one(),
            five: create_wrapper_five(),
        }
    }
}


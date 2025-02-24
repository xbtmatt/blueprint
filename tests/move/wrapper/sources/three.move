module wrapper::three {
    use std::string::{Self, String};
    use std::option::{Self, Option};
    use arguments::example::{SomeResource};
    use wrapper::one::{WrapperOne};
    use wrapper::two::{WrapperTwo};

    struct WrapperThree has key {
        some_resource: SomeResource<bool, bool, bool>,
        my_bool_3: bool,
        my_u64_3: u64,
        my_string_3: String,
        wrapper_one: WrapperOne<Three, Three, Three>,
        wrapper_two: WrapperTwo<Three, Three, Three>,        
    }
    
    struct Three has copy, drop, store {
        val1: u64,
        val2: bool,
        val3: Option<String>,
    }
    
    public fun create_three(): Three {
        Three {
            val1: 3,
            val2: true,
            val3: option::some(string::utf8(b"three?!!")),
        }
    }
}

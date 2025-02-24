module wrapper::two {
    use std::string::{Self, String};
    use std::option::{Self, Option};
    use arguments::example::{SomeResource};

    struct WrapperTwo<V1: copy + drop + store, V2: copy + drop + store, V3: copy + drop + store> has key, store {
        some_resource: SomeResource<V1, V2, V3>,
        my_bool_2: bool,
        my_u64_2: u64,
        my_string_2: String,
        two: Two,
    }
    
    struct Two has copy, drop, store {
        val1: u64,
        val2: bool,
        val3: Option<String>,
    }
    
    public fun create_two(): Two {
        Two {
            val1: 2,
            val2: false,
            val3: option::some(string::utf8(b"two!!!")),
        }
    }
    
    public fun custom_two(val1: u64, val2: bool, val3: Option<String>): Two {
        Two {
            val1,
            val2,
            val3,
        }
    }
}

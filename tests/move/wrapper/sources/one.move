module wrapper::one {
    use std::string::{Self, String};
    use std::option::{Self, Option};
    use arguments::example::{SomeResource};

    struct WrapperOne<V1: copy + drop + store, V2: copy + drop + store, V3: copy + drop + store> has key, store {
        some_resource: SomeResource<V1, V2, V3>,
        my_bool_1: bool,
        my_u64_1: u64,
        my_string_1: String,
        one: One,
    }
    
    struct One has copy, drop, store {
        val1: u64,
        val2: bool,
        val3: Option<String>,
    }
    
    public fun create_one(): One {
        One {
            val1: 1,
            val2: true,
            val3: option::some(string::utf8(b"one!")),
        }
    }
}

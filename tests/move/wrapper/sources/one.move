module wrapper::one {
    use std::string::{String};
    use arguments::example::{SomeResource};

    struct WrapperOne has key {
        some_resource: SomeResource<bool, u64, String>,
        my_bool: bool,
        my_u64: u64,
        my_string: String,
    }
}
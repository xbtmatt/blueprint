module wrapper::five {
    use arguments::example::{Self, SomeResource};
    use wrapper::one::{create_one, One};
    use wrapper::two::{create_two, Two};
    use wrapper::three::{create_three, Three};
    use wrapper::four::{Self};
    
    struct WrapperFive has copy, drop, store {
        one_two_three: SomeResource<One, Two, Three>,
        four: SomeResource<four::FourA, four::FourB, four::FourC>,
    }
    
    #[view]
    public fun view_two(): Two {
       create_two() 
    }
    
    public fun create_wrapper_five(): WrapperFive {
        let (a, b, c) = four::create_abc();

        WrapperFive {
            one_two_three: example::create_some_resource(
                create_one(),
                create_two(),
                create_three(),
            ),
            four: example::create_some_resource(a, b, c),
        }
    }
}

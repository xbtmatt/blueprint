module wrapper::four {
    struct FourA has copy, drop, store {
        val: u64,
    }
    
    struct FourB has copy, drop, store {
        val: u64,
    }

    struct FourC has copy, drop, store {
        val: u64,
    }
    
    #[view]
    public fun create_abc(): (FourA, FourB, FourC) {
        (FourA { val: 1 }, FourB { val: 2 }, FourC { val: 3 })
    }
}

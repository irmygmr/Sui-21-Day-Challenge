/// DAY 2: Primitive Types & Simple Functions
/// 
/// Today you will:
/// 1. Practice with primitive types (u64, bool)
/// 2. Write your first function
/// 3. Write your first test

module challenge::day_02 {
    #[test_only]
    use std::unit_test::assert_eq;

    // TODO: Write a function called 'sum' that takes two u64 numbers
    // and returns their sum
    // public fun sum(a: u64, b: u64): u64 {
    //     // Your code here
    // }

    // TODO: Write a test function that checks sum(1, 2) == 3
    // #[test]
    // fun test_sum() {
    //     // Your code here
  module 0x1::MyFirstModule {
    public fun sum(a: u64, b: u64): u64 {
        a + b
    }

    public fun is_equal(a: u64, b: u64): bool {
        a == b
    }

    #[test]
    fun test_sum() {
        let result = sum(1, 2);
        
        // assert! makrosu, parantez içindeki ifadenin doğru (true) olmasını bekler.
        // Eğer doğru değilse, yanındaki hata koduyla (0) işlemi durdurur.
        assert!(result == 3, 0);
    }
}

    // }

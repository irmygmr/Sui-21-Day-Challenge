/// DAY 3: Structs (Habit Model Skeleton)
/// 
/// Today you will:
/// 1. Learn about structs
/// 2. Create a Habit struct
/// 3. Write a constructor function

module challenge::day_03 {
    use std::vector;

    // TODO: Define a struct called 'Habit' with:
    // - name: vector<u8> (we'll use String later)
    // - completed: bool
    // Add 'copy' and 'drop' abilities
    // public struct Habit has copy, drop {
    //     // Your fields here
    // }

    // TODO: Write a constructor function 'new_habit'
    // that takes a name (vector<u8>) and returns a Habit
    // public fun new_habit(name: vector<u8>): Habit {
    //     // Your code here
    module 0x1::HabitTracker {

    /// 1. ve 2. ADIM: Struct Tanımlama
    public struct Habit has copy, drop {
        name: vector<u8>,
        completed: bool
    }

    public fun new_habit(name: vector<u8>): Habit {
        Habit {
            name: name,
            completed: false
        }
    }

    #[test]
    fun test_habit_creation() {
        let name = b"Book Reading";
        let my_habit = new_habit(name);
        
        assert!(my_habit.completed == false, 0);
    }
}
    // }


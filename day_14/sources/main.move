/// DAY 14: Tests for Bounty Board
/// 
/// Today you will:
/// 1. Write comprehensive tests
/// 2. Test all the functions you've created
/// 3. Practice test organization
///
/// Note: You can copy code from day_13/sources/solution.move if needed

module challenge::day_14 {
    use std::vector;
    use std::string::String;
    use std::option::{Self, Option};

    #[test_only]
    use std::unit_test::assert_eq;
    use std::string;

    // Copy from day_13: All structs and functions
    public enum TaskStatus has copy, drop {
        Open,
        Completed,
    }

    public struct Task has copy, drop {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    public struct TaskBoard has drop {
        owner: address,
        tasks: vector<Task>,
    }

    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    public fun new_board(owner: address): TaskBoard {
        TaskBoard {
            owner,
            tasks: vector::empty(),
        }
    }

    public fun add_task(board: &mut TaskBoard, task: Task) {
        vector::push_back(&mut board.tasks, task);
    }

    public fun complete_task(task: &mut Task) {
        task.status = TaskStatus::Completed;
    }

    public fun total_reward(board: &TaskBoard): u64 {
        let len = vector::length(&board.tasks);
        let mut total = 0;
        let mut i = 0;
        while (i < len) {
            let task = vector::borrow(&board.tasks, i);
            total = total + task.reward;
            i = i + 1;
        };
        total
    }

    public fun completed_count(board: &TaskBoard): u64 {
        let len = vector::length(&board.tasks);
        let mut count = 0;
        let mut i = 0;
        while (i < len) {
            let task = vector::borrow(&board.tasks, i);
            if (task.status == TaskStatus::Completed) {
                count = count + 1;
            };
            i = i + 1;
        };
        count
    }

    // Note: assert! is a built-in macro in Move 2024 - no import needed!

    // TODO: Write at least 3 tests:
    // 
    // Test 1: test_create_board_and_add_task
    // - Create a board with an owner
    // - Add a task
    // - Verify the task was added
    // 
    // Test 2: test_complete_task
    // - Create board, add tasks
    // - Complete a task
    // - Verify completed_count is correct
    // 
    // Test 3: test_total_reward
    // - Create board, add multiple tasks with different rewards
    // - Verify total_reward is correct
    // 
    // #[test]
    // fun test_create_board_and_add_task() {
    //     // Your code here
    #[test]
    fun test_create_board_and_add_task() {
        let owner = @0x123;
        let mut board = new_board(owner);
        
        let task_title = string::utf8(b"Siber Guvenlik Odevi");
        let task = new_task(task_title, 100);
        
        add_task(&mut board, task);

        assert!(vector::length(&board.tasks) == 1, 0);
        assert!(board.owner == owner, 1);
    }

    #[test]

    fun test_complete_task() {
        let mut board = new_board(@0x456);
        
        let mut task1 = new_task(string::utf8(b"Move Calis"), 50);
        let task2 = new_task(string::utf8(b"Spor Yap"), 30);
       
        complete_task(&mut task1);
        
        add_task(&mut board, task1);
        add_task(&mut board, task2);

        assert!(completed_count(&board) == 1, 2);
    }

    #[test]
    fun test_total_reward() {
        let mut board = new_board(@0x789);
        
        add_task(&mut board, new_task(string::utf8(b"T1"), 150));
        add_task(&mut board, new_task(string::utf8(b"T2"), 200));
        add_task(&mut board, new_task(string::utf8(b"T3"), 50));
ı
        let total = total_reward(&board);
        
        assert!(total == 400, 3);
    }
}
    // }



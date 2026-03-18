/// DAY 9: Enums & TaskStatus
/// 
/// Today you will:
/// 1. Learn about enums
/// 2. Replace bool with an enum
/// 3. Use match expressions

module challenge::day_09 {
    use std::string::String;

    // Copy Task struct from day_08, but we'll update it

    // TODO: Define an enum called 'TaskStatus' with two variants:
    // - Open
    // - Completed
    // Add 'copy' and 'drop' abilities
    // public enum TaskStatus has copy, drop {
    //     Open,
    //     Completed,
    // }

    // TODO: Update Task struct to use TaskStatus instead of done: bool
    // public struct Task has copy, drop {
    //     title: String,
    //     reward: u64,
    //     status: TaskStatus,  // Changed from done: bool
    // }

    // TODO: Update new_task to set status = TaskStatus::Open
    // public fun new_task(title: String, reward: u64): Task {
    //     // Your code here

    public enum TaskStatus has copy, drop, store {
        Open,
        Completed,
    }
    public struct Task has copy, drop, store {
        title: String,
        reward: u64,
        status: TaskStatus,  // Changed from done: bool
    }

    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }
    // }

    // TODO: Write a function 'is_open' that checks if task.status == TaskStatus::Open
    // public fun is_open(task: &Task): bool {
    //     // Your code here
    public fun is_open(task: &Task): bool {
        // Move dilinde enum kontrolü için 'match' veya direkt erişim kullanılır
        match (task.status) {
            TaskStatus::Open => true,
            TaskStatus::Completed => false,
        }
    }
}
    //     // Hint: task.status == TaskStatus::Open
    // }


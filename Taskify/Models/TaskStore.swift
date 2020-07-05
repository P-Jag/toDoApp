import Foundation

class TaskStore {
    
    var tasks = [[Task](), [Task]()]
    
    //add new task
    func addTask(_ task: Task, at index: Int, isDone: Bool = false) {
        
        let section = isDone ? 1 : 0
        tasks[section].insert(task, at: index)
        
    }
    
    // remove task
   @discardableResult func removeTask(at index: Int, isDone: Bool = false) -> Task {
        
        let section = isDone ? 1 : 0
        return tasks[section].remove(at: index)
    }
}

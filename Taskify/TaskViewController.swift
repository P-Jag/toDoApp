import UIKit

class TaskViewController: UITableViewController {
    
    var taskStore = TaskStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toDoTasks = [Task(name: "Meditate"), Task(name: "Do shopping")]
        let doneTasks = [Task(name: "Make a laundry"), Task(name: "Read a book")]
        
        taskStore.tasks = [toDoTasks, doneTasks]
    }
    
}

// MARK: - Data Source

extension TaskViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore.tasks[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = tableView.dequeueReusableCell(withIdentifier: "Task", for: indexPath)
        task.textLabel?.text = taskStore.tasks[indexPath.section][indexPath.row].name
        return task
    }
}

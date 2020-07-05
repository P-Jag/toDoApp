import UIKit

class TaskViewController: UITableViewController {
    
    var taskStore: TaskStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
    }
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add task", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let name = alertController.textFields?.first?.text else { return }
            
            let newTask = Task(name: name)
            self.taskStore.addTask(newTask, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        addAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter task name..."
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc private func handleTextChanged(_ sender: UITextField) {
        
    guard let alertController = presentedViewController as? UIAlertController,
            let addAction = alertController.actions.first,
            let text = sender.text
            else {return}
    
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
}

// MARK: - Data Source

extension TaskViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "To do" : "Done"
    }
    
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

//MARK: - Delegate

extension TaskViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 42
       }
    
    //swipe right
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
            
            let isDone = self.taskStore.tasks[indexPath.section][indexPath.row].isDone
            self.taskStore.removeTask(at: indexPath.row, isDone: isDone)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "Delete")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.1450980392, blue: 0.168627451, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    //swipe left
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = UIContextualAction(style: .normal, title: nil) { (action, sourceView, completionHandler) in
         
            self.taskStore.tasks[0][indexPath.row].isDone = true
            let doneTask = self.taskStore.removeTask(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.taskStore.addTask(doneTask, at: 0, isDone: true)
            tableView.insertRows(at: [IndexPath.init(row: 0, section: 1)], with: .automatic)
            completionHandler(true)
        }
        
        doneAction.image = #imageLiteral(resourceName: "Done")
        doneAction.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.7529411765, blue: 0.2901960784, alpha: 1)
        
        //is done or not
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
}

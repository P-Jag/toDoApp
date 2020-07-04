import Foundation

class Task {
    var name: String
    var isDone: Bool
    
    init(name: String, isDone: Bool = false) {
        self.name = name
        self.isDone = isDone
    }
}

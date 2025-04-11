import Foundation

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var sortOption: SortOption = .dueDate
    @Published var filterOption: FilterOption = .all
    
    enum SortOption: String, CaseIterable {
        case dueDate = "截止日期"
        case priority = "优先级"
        case status = "状态"
        case title = "标题"
    }
    
    enum FilterOption: String, CaseIterable {
        case all = "全部"
        case pending = "待完成"
        case inProgress = "进行中"
        case completed = "已完成"
        case highPriority = "高优先级"
    }
    
    var filteredAndSortedTasks: [Task] {
        var filteredTasks = tasks
        
        // 应用筛选
        switch filterOption {
        case .pending:
            filteredTasks = tasks.filter { $0.status == .pending }
        case .inProgress:
            filteredTasks = tasks.filter { $0.status == .inProgress }
        case .completed:
            filteredTasks = tasks.filter { $0.status == .completed }
        case .highPriority:
            filteredTasks = tasks.filter { $0.priority == .high }
        case .all:
            break
        }
        
        // 应用排序
        switch sortOption {
        case .dueDate:
            filteredTasks.sort { $0.dueDate < $1.dueDate }
        case .priority:
            filteredTasks.sort { $0.priority.rawValue > $1.priority.rawValue }
        case .status:
            filteredTasks.sort { $0.status.rawValue < $1.status.rawValue }
        case .title:
            filteredTasks.sort { $0.title < $1.title }
        }
        
        return filteredTasks
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        saveTasks()
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            saveTasks()
        }
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }
    
    func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "tasks"),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        }
    }
} 
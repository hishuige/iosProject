import SwiftUI

struct EditTaskView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var taskManager: TaskManager
    let task: Task
    
    @State private var title: String
    @State private var description: String
    @State private var dueDate: Date
    @State private var priority: Task.Priority
    @State private var status: Task.Status
    
    init(taskManager: TaskManager, task: Task) {
        self.taskManager = taskManager
        self.task = task
        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description)
        _dueDate = State(initialValue: task.dueDate)
        _priority = State(initialValue: task.priority)
        _status = State(initialValue: task.status)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("任务信息")) {
                    TextField("标题", text: $title)
                    TextField("描述", text: $description)
                }
                
                Section(header: Text("截止日期")) {
                    DatePicker("选择日期", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: Text("优先级")) {
                    Picker("优先级", selection: $priority) {
                        ForEach(Task.Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                }
                
                Section(header: Text("状态")) {
                    Picker("状态", selection: $status) {
                        ForEach(Task.Status.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                }
            }
            .navigationTitle("编辑任务")
            .navigationBarItems(
                leading: Button("取消") {
                    dismiss()
                },
                trailing: Button("保存") {
                    let updatedTask = Task(
                        id: task.id,
                        title: title,
                        description: description,
                        dueDate: dueDate,
                        priority: priority,
                        status: status,
                        createdAt: task.createdAt
                    )
                    taskManager.updateTask(updatedTask)
                    dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
} 
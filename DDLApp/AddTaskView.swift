import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var taskManager: TaskManager
    
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @State private var priority = Task.Priority.medium
    @State private var status = Task.Status.pending
    
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
            .navigationTitle("添加新任务")
            .navigationBarItems(
                leading: Button("取消") {
                    dismiss()
                },
                trailing: Button("保存") {
                    let task = Task(
                        title: title,
                        description: description,
                        dueDate: dueDate,
                        priority: priority,
                        status: status,
                        createdAt: Date()
                    )
                    taskManager.addTask(task)
                    dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
} 
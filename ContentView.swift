import SwiftUI

struct ContentView: View {
    @StateObject private var taskManager = TaskManager()
    @State private var showingAddTask = false
    @State private var selectedTask: Task?
    @State private var showingEditTask = false
    @State private var showingSortMenu = false
    @State private var showingFilterMenu = false
    
    var body: some View {
        NavigationView {
            VStack {
                // 筛选和排序工具栏
                HStack {
                    Menu {
                        ForEach(TaskManager.FilterOption.allCases, id: \.self) { option in
                            Button(action: {
                                taskManager.filterOption = option
                            }) {
                                HStack {
                                    Text(option.rawValue)
                                    if taskManager.filterOption == option {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                            Text(taskManager.filterOption.rawValue)
                        }
                    }
                    
                    Spacer()
                    
                    Menu {
                        ForEach(TaskManager.SortOption.allCases, id: \.self) { option in
                            Button(action: {
                                taskManager.sortOption = option
                            }) {
                                HStack {
                                    Text(option.rawValue)
                                    if taskManager.sortOption == option {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.up.arrow.down.circle")
                            Text(taskManager.sortOption.rawValue)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                List {
                    ForEach(taskManager.filteredAndSortedTasks) { task in
                        TaskRow(task: task)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedTask = task
                                showingEditTask = true
                            }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            taskManager.deleteTask(taskManager.filteredAndSortedTasks[index])
                        }
                    }
                }
            }
            .navigationTitle("DDL 任务")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(taskManager: taskManager)
            }
            .sheet(isPresented: $showingEditTask) {
                if let task = selectedTask {
                    EditTaskView(taskManager: taskManager, task: task)
                }
            }
        }
        .onAppear {
            taskManager.loadTasks()
        }
    }
}

struct TaskRow: View {
    let task: Task
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(task.title)
                .font(.headline)
            Text("截止日期: \(task.dueDate.formatted(date: .abbreviated, time: .shortened))")
                .font(.subheadline)
            Text("剩余天数: \(task.daysUntilDue)天")
                .font(.caption)
                .foregroundColor(task.daysUntilDue < 3 ? .red : .gray)
            HStack {
                Text("优先级: \(task.priority.rawValue)")
                    .font(.caption)
                Spacer()
                Text("状态: \(task.status.rawValue)")
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
} 
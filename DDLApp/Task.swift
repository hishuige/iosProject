import Foundation

struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var dueDate: Date
    var priority: Priority
    var status: Status
    var createdAt: Date
    
    enum Priority: String, Codable, CaseIterable {
        case low = "低"
        case medium = "中"
        case high = "高"
    }
    
    enum Status: String, Codable, CaseIterable {
        case pending = "待完成"
        case inProgress = "进行中"
        case completed = "已完成"
    }
    
    var daysUntilDue: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: dueDate).day ?? 0
    }
} 
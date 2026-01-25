import Foundation
import SwiftUI

enum Priority: String, CaseIterable, Identifiable, Codable {
    case low = "Низкий"
    case medium = "Средний"
    case high = "Высокий"
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .low: return "arrow.down.circle"
        case .medium: return "equal.circle"
        case .high: return "exclamationmark.triangle.fill"
        }
    }
}

struct TodoItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var priority: Priority
    var createdAt: Date
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, priority: Priority = .medium) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.priority = priority
        self.createdAt = Date()
    }
}
import SwiftUI

struct TaskRow: View {
    @Binding var item: TodoItem
    
    var body: some View {
        HStack(spacing: 16) {
            // Completion Indicator
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    item.isCompleted.toggle()
                }
            } label: {
                ZStack {
                    Circle()
                        .stroke(item.priority.color, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if item.isCompleted {
                        Circle()
                            .fill(item.priority.color)
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .buttonStyle(.plain)
            
            // Task Content
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(item.isCompleted ? .secondary : .primary)
                    .strikethrough(item.isCompleted)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 6) {
                    Image(systemName: item.priority.icon)
                        .font(.system(size: 11))
                        .foregroundColor(item.priority.color)
                    
                    Text(item.priority.rawValue)
                        .font(.system(size: 13))
                        .foregroundColor(item.priority.color)
                    
                    Spacer()
                    
                    Text(formatDate(item.createdAt))
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .contentShape(Rectangle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
}
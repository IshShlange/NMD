import SwiftUI

struct ContentView: View {
    @State private var todoItems: [TodoItem] = [
        TodoItem(title: "Купить продукты", priority: .high),
        TodoItem(title: "Сделать домашнее задание", priority: .medium),
        TodoItem(title: "Позвонить маме", priority: .low),
        TodoItem(title: "Записаться к врачу", isCompleted: true, priority: .high),
        TodoItem(title: "Прочитать книгу", priority: .low)
    ]
    
    @State private var showAddSheet = false
    @State private var filter: TaskFilter = .all
    
    enum TaskFilter {
        case all, active, completed
    }
    
    var filteredItems: [TodoItem] {
        switch filter {
        case .all:
            return todoItems
        case .active:
            return todoItems.filter { !$0.isCompleted }
        case .completed:
            return todoItems.filter { $0.isCompleted }
        }
    }
    
    var activeTasksCount: Int {
        todoItems.filter { !$0.isCompleted }.count
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Мои задачи")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Активных задач: \(activeTasksCount)")
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    // Filter Picker
                    Picker("Фильтр", selection: $filter) {
                        Text("Все").tag(TaskFilter.all)
                        Text("Активные").tag(TaskFilter.active)
                        Text("Выполненные").tag(TaskFilter.completed)
                    }
                    .pickerStyle(.segmented)
                    .padding(.top, 8)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 20)
                .background(
                    Color(.systemBackground)
                        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                )
                
                // Tasks List
                if filteredItems.isEmpty {
                    EmptyStateView(filter: filter)
                } else {
                    List {
                        ForEach($filteredItems) { $item in
                            TaskRow(item: $item)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .padding(.vertical, 4)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        withAnimation(.spring()) {
                                            deleteTask(item)
                                        }
                                    } label: {
                                        Label("Удалить", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddTaskView(todoItems: $todoItems)
            }
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private func deleteTask(_ task: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == task.id }) {
            todoItems.remove(at: index)
        }
    }
}

struct EmptyStateView: View {
    let filter: ContentView.TaskFilter
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checklist")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
                .padding(.top, 100)
            
            Text(filter == .completed ? "Нет выполненных задач" : 
                 filter == .active ? "Все задачи выполнены! 🎉" : "Нет задач")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.secondary)
            
            if filter != .all {
                Text("Создайте новую задачу или измените фильтр")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary.opacity(0.8))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
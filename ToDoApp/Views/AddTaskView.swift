import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var todoItems: [TodoItem]
    
    @State private var taskTitle = ""
    @State private var selectedPriority: Priority = .medium
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Название задачи", text: $taskTitle, axis: .vertical)
                        .lineLimit(3...6)
                } header: {
                    Text("Детали задачи")
                        .font(.headline)
                }
                
                Section {
                    Picker("Приоритет", selection: $selectedPriority) {
                        ForEach(Priority.allCases) { priority in
                            HStack {
                                Image(systemName: priority.icon)
                                    .foregroundColor(priority.color)
                                Text(priority.rawValue)
                            }
                            .tag(priority)
                        }
                    }
                    .pickerStyle(.navigationLink)
                } header: {
                    Text("Приоритет")
                        .font(.headline)
                }
                
                Section {
                    Button(action: saveTask) {
                        HStack {
                            Spacer()
                            Text("Сохранить задачу")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(taskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .foregroundColor(.white)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(taskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 
                                  Color.gray : Color.blue)
                            .padding(.horizontal, 8)
                    )
                }
            }
            .navigationTitle("Новая задача")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
            .alert("Внимание", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Пожалуйста, введите название задачи")
            }
        }
        .interactiveDismissDisabled()
    }
    
    private func saveTask() {
        let trimmedTitle = taskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            showAlert = true
            return
        }
        
        let newTask = TodoItem(
            title: trimmedTitle,
            priority: selectedPriority
        )
        
        todoItems.append(newTask)
        dismiss()
    }
}
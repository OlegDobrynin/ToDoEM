import Foundation
import CoreData

// MARK: - Protocol

protocol StorageServiceProtocol {
    func fetchTasks() -> [TaskModel]
    func addTask(_ task: TaskModel)
    func updateTask(_ task: TaskModel)
    func deleteTask(id: Int)
}

// MARK: - Service

final class StorageService: StorageServiceProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Fetch
    
    func fetchTasks() -> [TaskModel] {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        
        do {
            return try context.fetch(request).map { $0.toModel() }
        } catch {
            print("Fetch error:", error)
            return []
        }
    }
    
    // MARK: - Add
    
    func addTask(_ task: TaskModel) {
        let entity = TaskEntity(context: context)
        entity.apply(task)
        save()
    }
    
    // MARK: - Update
    
    func updateTask(_ task: TaskModel) {
        guard let entity = findEntity(by: task.id) else { return }
        entity.apply(task)
        save()
    }
    
    // MARK: - Delete
    
    func deleteTask(id: Int) {
        guard let entity = findEntity(by: id) else { return }
        context.delete(entity)
        save()
    }
    
    // MARK: - Private
    
    private func findEntity(by id: Int) -> TaskEntity? {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %d", id)
        
        return try? context.fetch(request).first
    }
    
    private func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error:", error)
            }
        }
    }
}

// MARK: - Mapping

extension TaskEntity {
    
    func apply(_ model: TaskModel) {
        id = Int64(model.id)
        title = model.title
        taskDescription = model.description
        createdAt = model.createdAt
        isCompleted = model.isCompleted
    }
    
    func toModel() -> TaskModel {
        TaskModel(
            id: Int(id),
            title: title ?? "",
            description: taskDescription ?? "",
            createdAt: createdAt ?? Date(),
            isCompleted: isCompleted
        )
    }
}

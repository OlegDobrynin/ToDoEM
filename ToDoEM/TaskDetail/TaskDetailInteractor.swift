import Foundation

// MARK: - Protocol

protocol TaskDetailInteractorInput {
    func saveTask(_ task: TaskModel)
}

// MARK: - Interactor

final class TaskDetailInteractor: TaskDetailInteractorInput {

    private let onUpdate: (TaskModel) -> Void

    init(onUpdate: @escaping (TaskModel) -> Void) {
        self.onUpdate = onUpdate
    }

    func saveTask(_ task: TaskModel) {
        onUpdate(task)
    }
}

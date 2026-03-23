import Foundation

// MARK: - Protocol

protocol NetworkServiceProtocol {
    func fetchTodos(completion: @escaping ([TaskModel]) -> Void)
}

// MARK: - Service

final class NetworkService: NetworkServiceProtocol {

    func fetchTodos(completion: @escaping ([TaskModel]) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos?limit=30") else {
            completion([]); return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard
                let data,
                let response = try? JSONDecoder().decode(TodosResponse.self, from: data)
            else {
                DispatchQueue.main.async { completion([]) }
                return
            }

            // id -> title (заголовок), todo -> description (описание)
            let tasks = response.todos.map { item in
                TaskModel(
                    id: item.id,
                    title: "\(item.id)",
                    description: item.todo,
                    createdAt: Date(),
                    isCompleted: item.completed
                )
            }
            DispatchQueue.main.async { completion(tasks) }
        }.resume()
    }
}

// MARK: - DTOs

private struct TodosResponse: Decodable {
    let todos: [TodoItem]
}

private struct TodoItem: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
}

//
//  Task.swift
//  ToDoEM
//
//  Created by olegg on 19.03.2026.
//
import Foundation

struct Task {
    let id: Int
    var title: String
    var description: String?
    var createdAt: Date
    var isCompleted: Bool
}

let mockTasks: [Task] = [
    Task(
        id: 1,
        title: "Купить продукты",
        description: "Молоко, хлеб, яйца",
        createdAt: Date(),
        isCompleted: false
    ),
    Task(
        id: 2,
        title: "Сделать тренировку",
        description: "30 минут кардио",
        createdAt: Date().addingTimeInterval(-3600 * 5),
        isCompleted: true
    ),
    Task(
        id: 3,
        title: "Прочитать книгу",
        description: "Минимум 20 страниц",
        createdAt: Date().addingTimeInterval(-3600 * 24),
        isCompleted: false
    ),
    Task(
        id: 4,
        title: "Написать код",
        description: nil,
        createdAt: Date().addingTimeInterval(-3600 * 48),
        isCompleted: false
    ),
    Task(
        id: 5,
        title: "тест",
        description: nil,
        createdAt: Date().addingTimeInterval(-3600 * 48),
        isCompleted: false
    ),
    Task(
        id: 6,
        title: "тест2",
        description: "dsdsdsdsdsd",
        createdAt: Date().addingTimeInterval(-3600 * 48),
        isCompleted: true
    ),
    Task(
        id: 7,
        title: "тест3",
        description: nil,
        createdAt: Date().addingTimeInterval(-3600 * 48),
        isCompleted: false
    )
]

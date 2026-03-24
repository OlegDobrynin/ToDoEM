import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    private let container: NSPersistentContainer

    var context: NSManagedObjectContext { container.viewContext }
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()

    private init() {
        container = NSPersistentContainer(name: "TasksEntity")
        container.loadPersistentStores { _, error in
            if let error { fatalError("CoreData error: \(error)") }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

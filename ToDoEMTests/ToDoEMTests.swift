import XCTest
@testable import ToDoEM

// MARK: - Mocks

final class MockTaskListView: TaskListViewProtocol {
    var showTasksCalled = false
    var receivedTasks: [TaskModel] = []

    func showTasks(_ tasks: [TaskModel]) {
        showTasksCalled = true
        receivedTasks = tasks
    }
}

final class MockTaskListInteractor: TaskListInteractorInput {
    var fetchTasksCalled = false
    var addNewTaskCalled = false
    var toggleTaskId: Int?
    var deleteTaskId: Int?
    var updatedTask: TaskModel?
    var newTaskStub = TaskModel(id: 42, title: "", description: "", createdAt: Date(), isCompleted: false)

    func fetchTasks() { fetchTasksCalled = true }
    func addNewTask() -> TaskModel { addNewTaskCalled = true; return newTaskStub }
    func toggleTask(id: Int) { toggleTaskId = id }
    func deleteTask(id: Int) { deleteTaskId = id }
    func updateTask(_ task: TaskModel) { updatedTask = task }
}

final class MockTaskListRouter: TaskListRouterProtocol {
    var navigateCalled = false
    var navigatedTask: TaskModel?
    var capturedOnUpdate: ((TaskModel) -> Void)?
    var showShareSheetCalled = false
    var sharedTask: TaskModel?

    func navigateToTaskDetail(task: TaskModel, onUpdate: @escaping (TaskModel) -> Void) {
        navigateCalled = true
        navigatedTask = task
        capturedOnUpdate = onUpdate
    }

    func showShareSheet(task: TaskModel) {
        showShareSheetCalled = true
        sharedTask = task
    }
}

final class MockTaskDetailView: TaskDetailViewProtocol {
    var showTaskCalled = false
    var receivedTask: TaskModel?

    func showTask(_ task: TaskModel) {
        showTaskCalled = true
        receivedTask = task
    }
}

final class MockTaskDetailInteractor: TaskDetailInteractorInput {
    var saveTaskCalled = false
    var savedTask: TaskModel?

    func saveTask(_ task: TaskModel) {
        saveTaskCalled = true
        savedTask = task
    }
}

final class MockTaskDetailRouter: TaskDetailRouterProtocol {
    var navigateBackCalled = false

    func navigateBack() { navigateBackCalled = true }
}

final class MockStorageService: StorageServiceProtocol {
    var tasksToReturn: [TaskModel] = []
    var addedTasks: [TaskModel] = []
    var updatedTasks: [TaskModel] = []
    var deletedIds: [Int] = []

    func fetchTasks() -> [TaskModel] { tasksToReturn }
    func addTask(_ task: TaskModel) { addedTasks.append(task) }
    func updateTask(_ task: TaskModel) { updatedTasks.append(task) }
    func deleteTask(id: Int) { deletedIds.append(id) }
}

final class MockNetworkService: NetworkServiceProtocol {
    var fetchTodosCalled = false
    var tasksToReturn: [TaskModel] = []

    func fetchTodos(completion: @escaping ([TaskModel]) -> Void) {
        fetchTodosCalled = true
        completion(tasksToReturn)
    }
}

final class MockInteractorOutput: TaskListInteractorOutput {
    var didFetchTasksCalled = false
    var receivedTasks: [TaskModel] = []
    var onFetch: (() -> Void)?

    func didFetchTasks(_ tasks: [TaskModel]) {
        didFetchTasksCalled = true
        receivedTasks = tasks
        onFetch?()
    }
}

// MARK: - Factory helpers

private func makeTask(
    id: Int = 1,
    title: String = "Test",
    description: String = "Desc",
    isCompleted: Bool = false
) -> TaskModel {
    TaskModel(id: id, title: title, description: description, createdAt: Date(), isCompleted: isCompleted)
}

private func makeListPresenter() -> (
    presenter: TaskListPresenter,
    view: MockTaskListView,
    interactor: MockTaskListInteractor,
    router: MockTaskListRouter
) {
    let view = MockTaskListView()
    let interactor = MockTaskListInteractor()
    let router = MockTaskListRouter()
    let presenter = TaskListPresenter()
    presenter.view = view
    presenter.interactor = interactor
    presenter.router = router
    return (presenter, view, interactor, router)
}

private func makeDetailPresenter(task: TaskModel) -> (
    presenter: TaskDetailPresenter,
    view: MockTaskDetailView,
    interactor: MockTaskDetailInteractor,
    router: MockTaskDetailRouter
) {
    let view = MockTaskDetailView()
    let interactor = MockTaskDetailInteractor()
    let router = MockTaskDetailRouter()
    let presenter = TaskDetailPresenter()
    presenter.view = view
    presenter.interactor = interactor
    presenter.router = router
    presenter.task = task
    return (presenter, view, interactor, router)
}

// MARK: - TaskListPresenterTests

final class TaskListPresenterTests: XCTestCase {

    func test_viewDidLoad_callsFetchTasks() {
        let (presenter, _, interactor, _) = makeListPresenter()

        presenter.viewDidLoad()

        XCTAssertTrue(interactor.fetchTasksCalled)
    }

    func test_didToggleTask_callsInteractorWithCorrectId() {
        let (presenter, _, interactor, _) = makeListPresenter()

        presenter.didToggleTask(id: 7)

        XCTAssertEqual(interactor.toggleTaskId, 7)
    }

    func test_didDeleteTask_callsInteractorWithCorrectId() {
        let (presenter, _, interactor, _) = makeListPresenter()

        presenter.didDeleteTask(id: 3)

        XCTAssertEqual(interactor.deleteTaskId, 3)
    }

    func test_didSelectTask_navigatesToDetailWithTask() {
        let (presenter, _, _, router) = makeListPresenter()
        let task = makeTask(id: 5, title: "Selected")

        presenter.didSelectTask(task)

        XCTAssertTrue(router.navigateCalled)
        XCTAssertEqual(router.navigatedTask?.id, 5)
    }

    func test_didShareTask_callsRouterShareSheet() {
        let (presenter, _, _, router) = makeListPresenter()
        let task = makeTask(title: "Share me")

        presenter.didShareTask(task)

        XCTAssertTrue(router.showShareSheetCalled)
        XCTAssertEqual(router.sharedTask?.title, "Share me")
    }

    func test_didTapAddButton_createsTaskAndNavigates() {
        let (presenter, _, interactor, router) = makeListPresenter()

        presenter.didTapAddButton()

        XCTAssertTrue(interactor.addNewTaskCalled)
        XCTAssertTrue(router.navigateCalled)
        XCTAssertEqual(router.navigatedTask?.id, interactor.newTaskStub.id)
    }

    func test_didTapAddButton_onUpdateCallbackForwardsToInteractor() {
        let (presenter, _, interactor, router) = makeListPresenter()
        presenter.didTapAddButton()

        let updatedTask = makeTask(id: 42, title: "Updated")
        router.capturedOnUpdate?(updatedTask)

        XCTAssertEqual(interactor.updatedTask?.id, 42)
        XCTAssertEqual(interactor.updatedTask?.title, "Updated")
    }

    func test_didFetchTasks_passesTasksToView() {
        let (presenter, view, _, _) = makeListPresenter()
        let tasks = [makeTask(id: 1), makeTask(id: 2)]

        presenter.didFetchTasks(tasks)

        XCTAssertTrue(view.showTasksCalled)
        XCTAssertEqual(view.receivedTasks.count, 2)
        XCTAssertEqual(view.receivedTasks[0].id, 1)
        XCTAssertEqual(view.receivedTasks[1].id, 2)
    }
}

// MARK: - TaskDetailPresenterTests

final class TaskDetailPresenterTests: XCTestCase {

    func test_viewDidLoad_showsTaskInView() {
        let task = makeTask(title: "My task")
        let (presenter, view, _, _) = makeDetailPresenter(task: task)

        presenter.viewDidLoad()

        XCTAssertTrue(view.showTaskCalled)
        XCTAssertEqual(view.receivedTask?.title, "My task")
    }

    func test_viewWillDisappear_savesUpdatedTitleAndDescription() {
        let task = makeTask(id: 10)
        let (presenter, _, interactor, _) = makeDetailPresenter(task: task)

        presenter.viewWillDisappear(title: "New title", description: "New desc")

        XCTAssertTrue(interactor.saveTaskCalled)
        XCTAssertEqual(interactor.savedTask?.title, "New title")
        XCTAssertEqual(interactor.savedTask?.description, "New desc")
    }

    func test_viewWillDisappear_preservesOriginalId() {
        let task = makeTask(id: 99)
        let (presenter, _, interactor, _) = makeDetailPresenter(task: task)

        presenter.viewWillDisappear(title: "T", description: "D")

        XCTAssertEqual(interactor.savedTask?.id, 99)
    }
}

// MARK: - TaskListInteractorTests

final class TaskListInteractorTests: XCTestCase {

    func test_fetchTasks_withStoredTasks_doesNotCallNetwork() {
        let storage = MockStorageService()
        let network = MockNetworkService()
        storage.tasksToReturn = [makeTask(id: 1), makeTask(id: 2)]

        let interactor = TaskListInteractor(storage: storage, network: network)
        let output = MockInteractorOutput()
        interactor.output = output

        let exp = expectation(description: "output called")
        output.onFetch = { exp.fulfill() }

        interactor.fetchTasks()
        wait(for: [exp], timeout: 1)

        XCTAssertFalse(network.fetchTodosCalled)
        XCTAssertEqual(output.receivedTasks.count, 2)
    }

    func test_fetchTasks_withEmptyStorage_fetchesFromNetworkAndSaves() {
        let storage = MockStorageService()
        let network = MockNetworkService()
        network.tasksToReturn = [makeTask(id: 5)]

        let interactor = TaskListInteractor(storage: storage, network: network)
        let output = MockInteractorOutput()
        interactor.output = output

        let exp = expectation(description: "output called")
        output.onFetch = { exp.fulfill() }

        interactor.fetchTasks()
        wait(for: [exp], timeout: 1)

        XCTAssertTrue(network.fetchTodosCalled)
        XCTAssertEqual(storage.addedTasks.count, 1)
        XCTAssertEqual(storage.addedTasks.first?.id, 5)
    }

    func test_deleteTask_callsStorageDeleteAndNotifiesOutput() {
        let storage = MockStorageService()
        storage.tasksToReturn = [makeTask(id: 1)]

        let interactor = TaskListInteractor(storage: storage, network: MockNetworkService())
        let output = MockInteractorOutput()
        interactor.output = output

        let exp = expectation(description: "output called")
        output.onFetch = { exp.fulfill() }

        interactor.deleteTask(id: 1)
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(storage.deletedIds, [1])
        XCTAssertTrue(output.didFetchTasksCalled)
    }

    func test_toggleTask_flipsIsCompletedInStorage() {
        let storage = MockStorageService()
        storage.tasksToReturn = [makeTask(id: 1, isCompleted: false)]

        let interactor = TaskListInteractor(storage: storage, network: MockNetworkService())
        let output = MockInteractorOutput()
        interactor.output = output

        let exp = expectation(description: "output called")
        output.onFetch = { exp.fulfill() }

        interactor.toggleTask(id: 1)
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(storage.updatedTasks.first?.isCompleted, true)
    }

    func test_addNewTask_returnsTaskAndSavesToStorage() {
        let storage = MockStorageService()

        let interactor = TaskListInteractor(storage: storage, network: MockNetworkService())
        let output = MockInteractorOutput()
        interactor.output = output

        let exp = expectation(description: "output called")
        output.onFetch = { exp.fulfill() }

        let returned = interactor.addNewTask()
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(storage.addedTasks.first?.id, returned.id)
    }
}

// MARK: - TaskDetailInteractorTests

final class TaskDetailInteractorTests: XCTestCase {

    func test_saveTask_callsOnUpdateWithCorrectTask() {
        var receivedTask: TaskModel?
        let interactor = TaskDetailInteractor { receivedTask = $0 }

        let task = makeTask(id: 1, title: "Done", description: "Finished")
        interactor.saveTask(task)

        XCTAssertEqual(receivedTask?.id, 1)
        XCTAssertEqual(receivedTask?.title, "Done")
        XCTAssertEqual(receivedTask?.description, "Finished")
    }

    func test_saveTask_preservesCompletionState() {
        var receivedTask: TaskModel?
        let interactor = TaskDetailInteractor { receivedTask = $0 }

        let task = makeTask(isCompleted: true)
        interactor.saveTask(task)

        XCTAssertEqual(receivedTask?.isCompleted, true)
    }
}

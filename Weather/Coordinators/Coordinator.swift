
protocol Coordinator: AnyObject {
    var childrenCoordinators: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    func didFinish(child: Coordinator) {
        for (index, coordinator) in childrenCoordinators.enumerated() {
            if coordinator === child {
                childrenCoordinators.remove(at: index)
            }
        }
    }
}

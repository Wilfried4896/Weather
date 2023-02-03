//
//  Coordinator.swift
//  Weather
//
//  Created by Вилфриэд Оди on 30.11.2022.
//

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

//
//  OnboardingCoordinator.swift
//  Weather
//
//  Created by Вилфриэд Оди on 30.11.2022.
//

import UIKit

class OnboardingCoordinator: Coordinator {
    
    weak var parent: AppCoordinator?
    var navigation: UINavigationController
    var childrenCoordinators: [Coordinator] = []
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        onboardingVC()
    }
    
    func onboardingVC() {
        let vc = OnboardingController()
        vc.coordinator = self
        navigation.pushViewController(vc, animated: true)
    }
}

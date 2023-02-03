//
//  AppCoordinator.swift
//  Weather
//
//  Created by Вилфриэд Оди on 30.11.2022.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var window: UIWindow?
    var navigation: UIViewController?
    var childrenCoordinators: [Coordinator] = []
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        window?.makeKeyAndVisible()
       
        onboardingCoordinator()
    }
    
    func onboardingCoordinator() {
        navigation = UINavigationController()
        window?.rootViewController = navigation
        
        let onboardingCoord = OnboardingCoordinator(navigation: navigation as! UINavigationController)
        onboardingCoord.parent = self
        childrenCoordinators.append(onboardingCoord)
        onboardingCoord.start()
    }
    
    func homePage() {
        navigation = UINavigationController()
        window?.rootViewController = navigation
        
        let homePageCoordiantor = HomePageCoordinator(navigation: navigation as! UINavigationController)
        homePageCoordiantor.parent = self
        childrenCoordinators.append(homePageCoordiantor)
        homePageCoordiantor.start()
    }
}


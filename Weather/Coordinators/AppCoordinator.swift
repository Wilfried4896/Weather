
import UIKit
import CoreLocation

class AppCoordinator: Coordinator, LocationCoordinateDelegate {
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
    
    func didTapToKnowCoordinate(locationCoordinate: CLLocation?) {
        navigation = UINavigationController()
        window?.rootViewController = navigation
        
        let homePageCoordiantor = HomePageCoordinator(navigation: navigation as! UINavigationController, coreLocation: locationCoordinate)
        homePageCoordiantor.parent = self
        childrenCoordinators.append(homePageCoordiantor)
        homePageCoordiantor.start()
    }
}


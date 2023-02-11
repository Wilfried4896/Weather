
import UIKit

class AppCoordinator: Coordinator, LocationCoordinateDelegate {
    var window: UIWindow?
    var navigation: UIViewController?
    var childrenCoordinators: [Coordinator] = []
    var locationCoor: [Double]?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        window?.makeKeyAndVisible()
        onboardingCoordinator()
    }
    
    func didTapToKnowCoordinate(locationCoordinate: [Double]?) {
        locationCoor = locationCoordinate
    }
    
    func onboardingCoordinator() {
        navigation = UINavigationController()
        window?.rootViewController = navigation
        
        let onboardingCoord = OnboardingCoordinator(navigation: navigation as! UINavigationController)
        onboardingCoord.parent = self
        childrenCoordinators.append(onboardingCoord)
        onboardingCoord.start()
    }
    
    func homeCoordinator() {
        navigation = UINavigationController()
        window?.rootViewController = navigation
        
        let homePageCoordiantor = HomePageCoordinator(navigation: navigation as! UINavigationController, coreLocation: locationCoor)
        print(locationCoor)
        homePageCoordiantor.parent = self
        childrenCoordinators.append(homePageCoordiantor)
        homePageCoordiantor.start()
    }
}


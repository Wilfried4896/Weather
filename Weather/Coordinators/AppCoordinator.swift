
import UIKit

class AppCoordinator: Coordinator {
    var window: UIWindow?
    var navigation: UIViewController?
    var childrenCoordinators: [Coordinator] = []
    var locationCoor: [Double]?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        window?.makeKeyAndVisible()
        if UserDefaults.standard.bool(forKey: "isConnected") {
            homeCoordinator()
        } else {
            onboardingCoordinator()
        }
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
        homePageCoordiantor.parent = self
        childrenCoordinators.append(homePageCoordiantor)
        homePageCoordiantor.start()
    }
}


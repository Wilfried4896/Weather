
import UIKit
import CoreLocation

class HomePageCoordinator: Coordinator {

    weak var parent: AppCoordinator?
    var childrenCoordinators: [Coordinator] = []
    var navigation: UINavigationController
    var coreLocation: [Double]?
    
    init(navigation: UINavigationController, coreLocation: [Double]?) {
        self.navigation = navigation
        self.coreLocation = coreLocation
    }
    
    func start() {
        homePageVC()
    }
    
    func homePageVC() {
        let vc = PageViewController()
        vc.coordinator = self
        navigation.pushViewController(vc, animated: true)
    }
    
    func paramatrPage() {
        let vc = ParameterController()
        vc.coordinator = self
        navigation.pushViewController(vc, animated: true)
    }
}

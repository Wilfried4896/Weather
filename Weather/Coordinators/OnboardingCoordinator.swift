
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

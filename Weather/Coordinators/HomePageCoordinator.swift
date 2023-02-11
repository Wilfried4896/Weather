
import UIKit
import CoreLocation

protocol HomePageDelegate: AnyObject {
    func indexPathSelect(indexS: IndexPath)
}

class HomePageCoordinator: Coordinator, HomePageDelegate {

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
        let vc = HomePageController()
        //print(coreLocation)
        vc.coordinator = self
        //vc.locationCordinates = coreLocation
        navigation.pushViewController(vc, animated: true)
    }
    
    func paramatrPage() {
        let vc = ParameterController()
        vc.coordinator = self
        navigation.pushViewController(vc, animated: true)
    }
    
    func detailDay() {
        let vc = DetailHoursForecastController()
        vc.coordinator = self
        navigation.pushViewController(vc, animated: true)
    }
    
    func indexPathSelect(indexS: IndexPath) {
        let vc = DetailDayForecastController()
        vc.coordinator = self
        vc.indexSelect = indexS.row
        navigation.pushViewController(vc, animated: true)
    }
}

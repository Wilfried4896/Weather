//
//  HomePageCoordinator.swift
//  Weather
//
//  Created by Вилфриэд Оди on 30.11.2022.
//

import UIKit
import CoreLocation

protocol HomePageDelegate: AnyObject {
    func indexPathSelect(indexS: IndexPath)
}

class HomePageCoordinator: Coordinator, HomePageDelegate {

    weak var parent: AppCoordinator?
    var childrenCoordinators: [Coordinator] = []
    var navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        homePageVC()
    }
    
    func homePageVC() {
        let vc = HomePageController()
        vc.coordinator = self
        navigation.pushViewController(vc, animated: true)
    }
    
    func paramatrPage() {
        let vc = ParameterController()
        vc.coordinator = self
        navigation.present(vc, animated: true)
    }
    
    func detailDay() {
        let vc = DetailHoursForecastController()
        vc.coordinator = self
        navigation.pushViewController(vc, animated: true)
    }
    
    func indexPathSelect(indexS: IndexPath) {
        let vc = DetailDayForecastController()
        vc.coordinator = self
        vc.indexSelect = indexS.item
        navigation.pushViewController(vc, animated: true)
    }
}

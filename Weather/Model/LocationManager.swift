//
//  LocationManager.swift
//  Weather
//
//  Created by Вилфриэд Оди on 18.12.2022.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    var completion: ((CLLocation) -> Void)?
    
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        completion?(location)
        manager.stopUpdatingLocation()
    }
    
    func getCoordinate( addressString : String, completionHandler: @escaping ((CLLocation) -> Void)) {
        self.completion = completionHandler
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location)
                    return
                }
            }
            //completionHandler(kCLLocationCoordinate2DInvalid)
        }
    }
}


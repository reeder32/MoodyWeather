//
//  LocationManager.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 3/26/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    static let instance = LocationManager()
    var manager: CLLocationManager?
    var didAccept: ((Bool) -> Void)?
    var didGetLocation: ((CLLocation?, Error?) -> Void)?
  
    override init() {
        super.init()
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.requestWhenInUseAuthorization()
    }
    
    func start() {
        manager?.startUpdatingLocation()
    }
    
    func stop() {
        manager?.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            didGetLocation?(location, nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didGetLocation?(nil, error)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            didAccept?(true)
        default:
            didAccept?(false)
        }
    }
}

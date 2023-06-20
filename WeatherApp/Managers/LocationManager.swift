//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Juliana Pardal on 10/06/2023.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate {
    func didUpdateLocation()
}

final class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    let locationManager = CLLocationManager()
    var delegate: LocationManagerDelegate?
    
    var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationManagerAuthorization() {
        switch authorizationStatus() {
        case .notDetermined:
            print("Auth: notDetermined")
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            print("Auth: authorizedWhenInUse")
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Auth: denied")
            break
        default:
            break
        }
    }
    
    func authorizationStatus() -> CLAuthorizationStatus {
        var status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = CLLocationManager().authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        return status
    }
    
    func start() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        location = lastLocation.coordinate
        manager.stopUpdatingLocation()
        delegate?.didUpdateLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationManagerAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location", error)
        manager.stopUpdatingLocation()
    }
}

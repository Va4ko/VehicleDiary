//
//  MapViewController.swift
//  VehicleDiary
//
//  Created by Vachko on 19.10.20.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - IBActions
    @IBAction func gatMyLocationBtnTapped(_ sender: Any) {
        let newLocation = locationManager.location?.coordinate
        
        if newLocation != nil {
            let alert = UIAlertController(title: "You are in a location with coordinates:", message: "Latitude: \(newLocation!.latitude) Longitude: \(newLocation!.longitude)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default){ _ in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app is Settings.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default){ _ in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app is Settings.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default){ _ in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            
            self.present(alert, animated: true)
            
        default:
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = MKUserTrackingMode.follow
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Helper methods
    /// Centering map on location with 500 meters distance
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}

// MARK: - Extensions
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            if !mapHasCenteredOnce {
                centerMapOnLocation(location: loc)
                mapHasCenteredOnce = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView?.image = UIImage(named: "pointer")
        }
        return annotationView
    }
}

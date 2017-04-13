////
////  ViewController.swift
////  GeoLocationSaved
////
////  Created by mac on 4/12/17.
////  Copyright © 2017 mac. All rights reserved.
////
//
//import UIKit
//import MapKit
//import CoreLocation
//
//class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
//    
//{
//    @IBOutlet weak var bigMap: MKMapView!
//    
//    let locationManager = CLLocationManager()
//    let annotation = MKPointAnnotation()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
//        self.bigMap.showsUserLocation = true
//        bigMap.addAnnotation(annotation)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//               manager.stopUpdatingLocation()
//        let location = locations.last
//        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
//        
//        self.bigMap.setRegion(region, animated: true)
//        self.locationManager.stopUpdatingLocation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
//        
//        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
//            
//            if (error != nil) {
//                print("Reverse geocoder failed with error" + error!.localizedDescription)
//                return
//            }
//            if placemarks!.count > 0 {
//                let pm = placemarks![0]
//                if let location = manager.location {
//                    let userLoc = UserLocation(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude), timezone: NSTimeZone.local.identifier, city: pm.locality!, state: pm.administrativeArea!, country:pm.country!)
//                    
//                    //By printing this dictionary you will get the complete address
//                    print(pm.addressDictionary)
//                    
//                    print(userLoc.city!)
//                    print(userLoc.state!)
//                    print(userLoc.country!)
//                    print(userLoc.latitude!)
//                    print(userLoc.longitude!)
//                    print(userLoc.timeZone!)
//                    
//                } else {
//                    //Handle error
//                }
//                if(!CLGeocoder().isGeocoding){
//                    CLGeocoder().cancelGeocode()
//                }
//            }else{
//                print("Problem with the data received from geocoder")
//            }
//
//        })}
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Errors " + error.localizedDescription)
//        }
//}
//

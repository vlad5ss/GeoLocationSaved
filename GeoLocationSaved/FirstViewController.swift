//
//  FirstViewController.swift
//  GeoLocationSaved
//
//  Created by mac on 4/13/17.
//  Copyright © 2017 mac. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class FirstViewController: UIViewController, LocationManagerDelegate {

    @IBOutlet var mapView:MKMapView? = MKMapView()

    @IBOutlet weak var latitudeText: UILabel!

    @IBOutlet weak var longitudeText: UILabel!

    @IBOutlet weak var namePlace: UILabel!

    var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0, width: 50, height: 50)) as UIActivityIndicatorView

    var locationManager = LocationManager.sharedInstance

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = UIColor.blue
        locationManager.autoUpdate = true
        locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in

            if error != nil {
                print(error as Any)
            } else {
//                let geoCoder = CLGeocoder()
//                let location = CLLocation(latitude:latitude, longitude:longitude)
//                geoCoder.reverseGeocodeLocation(location)
//                {
//                    (placemarks, error) -> Void in
//
//                    let placeArray = placemarks as [CLPlacemark]!
//                    if(placeArray != nil){
//                        // Place details
//                        var placeMark: CLPlacemark!
//                        placeMark = placeArray?[0]
////     print(placeMark)
//                        // City
//                        if let city = placeMark.addressDictionary!["City"] as? NSString {
//                            print(city)
//                        }
//
//                        // Zip code
//                        if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
//                            print(zip)
//                        }
//                        // FormattedAddressLines
//                        if let FormattedAddressLines = placeMark.addressDictionary!["administrativeArea"] as? NSString {
//                                                    print(FormattedAddressLines)
//                        }
//
//                        // Country
//                        if let country = placeMark.addressDictionary!["Country"] as? NSString {
//                            print(country)
////                              self.longitudeText.text="\(country)"
//                        }
//
//                        }}
                self.plotOnMapWithCoordinates(latitude, longitude)
                self.latitudeText.text="\(latitude)"
                self.longitudeText.text="\(longitude)"
                    }
            }
        }

    func locationManagerStatus(_ status:NSString) {

        print(status)
    }

    func locationManagerReceivedError(_ error:NSString) {

        print(error)
        activityIndicator.stopAnimating()
    }

    func locationFound(_ latitude:Double, longitude:Double) {

        self.plotOnMapWithCoordinates(latitude, longitude)
    }

    func plotOnMapWithCoordinates(_ latitude: Double, _ longitude: Double) {

        locationManager.reverseGeocodeLocationUsingGoogleWithLatLon(latitude: latitude, longitude: longitude) { (reverseGeocodeInfo, placemark, error) -> Void in

            self.performActionWithPlacemark(placemark, error: error)
            let city = reverseGeocodeInfo?.value(forKey: "locality") as! String
            let country = reverseGeocodeInfo?.value(forKey: "country") as! String
            let formattedAddress = reverseGeocodeInfo?.value(forKey: "formattedAddress") as! String
            print("user Location \(formattedAddress )")
            self.namePlace.text=" \(country)"+" " + "\(city)"+" "+"\(formattedAddress )"

        }
    }


    func performActionWithPlacemark(_ placemark:CLPlacemark?,error:String?) {

        if error != nil {

            print(error as Any)

            (DispatchQueue.main).async(execute: { () -> Void in

                if self.activityIndicator.superview != nil {

                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.removeFromSuperview()
                }
            })
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
                self.plotPlacemarkOnMap(placemark)
            })
        }
    }

    func removeAllPlacemarkFromMap(_ shouldRemoveUserLocation:Bool) {

        if let mapView = self.mapView {
            for annotation in mapView.annotations{
                if shouldRemoveUserLocation {
                    if annotation as? MKUserLocation !=  mapView.userLocation {
                        mapView.removeAnnotation(annotation )
                    }
                }
            }
        }
    }

    func plotPlacemarkOnMap(_ placemark:CLPlacemark?) {

        removeAllPlacemarkFromMap(true)
        if self.locationManager.isRunning {
            self.locationManager.stopUpdatingLocation()
        }

        if self.activityIndicator.superview != nil {

            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }

        let latDelta:CLLocationDegrees = 0.1
        let longDelta:CLLocationDegrees = 0.1
        var _:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)

        let latitudinalMeters = 100.0
        let longitudinalMeters = 100.0
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(placemark!.location!.coordinate, latitudinalMeters, longitudinalMeters)

        self.mapView?.setRegion(theRegion, animated: true)

        self.mapView?.addAnnotation(MKPlacemark(placemark: placemark!))
    }
}


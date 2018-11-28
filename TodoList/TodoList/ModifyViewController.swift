//
//  ModifyViewController.swift
//  TodoList
//
//  Created by gaofeng on 2018/11/27.
//  Copyright © 2018年 com.gaofeng. All rights reserved.
//

import UIKit
import LocalAuthentication
import CoreLocation
import MapKit

class ModifyViewController: UIViewController, CLLocationManagerDelegate  {

    var locationManager: CLLocationManager = CLLocationManager()
    var cntLocation: CLLocation!
    var currLocation: CLLocation!
    
    var itemString:String?
    
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var todoContent: UITextField!
    @IBOutlet weak var map: MKMapView!
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func modifyBtn(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        todoContent.text = itemString
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        cntLocation = nil
        
        map.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locations.count == 0) { return }
        let cntLocation = locations[locations.count - 1]
        currLocation = locations.last!
        LonLatToCity()
        
        map.mapType = MKMapType.standard
        
        let latDelta = 0.005
        let longDelta = 0.005
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: currLocation.coordinate, span: currentLocationSpan)
        map.setRegion(currentRegion, animated: true)
        
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = currLocation.coordinate
        
        objectAnnotation.title = "您的位置"
        map.addAnnotation(objectAnnotation)
        
        
        print("latitude: \(cntLocation.coordinate.latitude), longitude: \(cntLocation.coordinate.longitude)")
    }
    
    
    func LonLatToCity(){
        let geocoder: CLGeocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(currLocation) { (placemarks, error) in
            print("地址：\(String(describing: placemarks?.first?.name))")
            print(String(describing: placemarks?.first?.name))
        }
    }

}

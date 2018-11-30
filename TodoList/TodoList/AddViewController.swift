//
//  AddViewController.swift
//  TodoList
//
//  Created by gaofeng on 2018/11/26.
//  Copyright © 2018年 com.gaofeng. All rights reserved.
//

import UIKit
import LocalAuthentication
import CoreLocation
import MapKit

class AddViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var cntLocation: CLLocation!
    var currLocation: CLLocation!
    
    var currentImage:Int = 1
    var content:String = ""
    var address:String = ""
    var longitude:Double = 0.0
    var latitude:Double = 0.0


    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var todoContent: UITextField!
    @IBOutlet weak var dataPicker: UIDatePicker!
    @IBOutlet weak var map: MKMapView!
    
    @IBAction func doneBtn(_ sender: Any) {
        content = todoContent.text!
        let date = dataPicker.date
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.settingNotification(date: date, body: content)
        }

        //insert task
        CoreDataManager.shared.insertTask(
            name: content, date: date, status: 1, type: Int16(currentImage),
            longitude: self.longitude,
            latitude: self.latitude,
            address: address)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image1.isUserInteractionEnabled = true
        image2.isUserInteractionEnabled = true
        image3.isUserInteractionEnabled = true
        image4.isUserInteractionEnabled = true
        let image1TapRecognition = UITapGestureRecognizer(target: self, action: #selector(image1Tapped));
        let image2TapRecognition = UITapGestureRecognizer(target: self, action: #selector(image2Tapped));
        let image3TapRecognition = UITapGestureRecognizer(target: self, action: #selector(image3Tapped));
        let image4TapRecognition = UITapGestureRecognizer(target: self, action: #selector(image4Tapped));
        
        image1.addGestureRecognizer(image1TapRecognition)
        image2.addGestureRecognizer(image2TapRecognition)
        image3.addGestureRecognizer(image3TapRecognition)
        image4.addGestureRecognizer(image4TapRecognition)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        cntLocation = nil
        
        map.showsUserLocation = true
        
    }
    
//    @objc func imageTapped(recognizer: UITapGestureRecognizer) {
//        let thePoint = recognizer.location(in: view)
//        let theView = recognizer.view
//    }
    
    @objc func image1Tapped(){
        changeImageViewBack(num: currentImage)
        currentImage = 1
        image1.image = UIImage(named: "poeple_selected")
    }
    
    @objc func image2Tapped(){
        changeImageViewBack(num: currentImage)
        currentImage = 2
        image2.image = UIImage(named: "shopping_selected")
    }
    
    @objc func image3Tapped(){
        changeImageViewBack(num: currentImage)
        currentImage = 3
        image3.image = UIImage(named: "call_selected")
    }
    
    @objc func image4Tapped(){
        changeImageViewBack(num: currentImage)
        currentImage = 4
        image4.image = UIImage(named: "plane_selected")
    }
    
    func changeImageViewBack(num: Int){
        switch num {
        case 1:
            image1.image = UIImage(named: "people")
        case 2:
            image2.image = UIImage(named: "shopping")
        case 3:
            image3.image = UIImage(named: "call")
        case 4:
            image4.image = UIImage(named: "plane")
        default:
            return
        }
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

        self.longitude = Double(cntLocation.coordinate.longitude)
        self.latitude = Double(cntLocation.coordinate.latitude)
        
        print("latitude: \(cntLocation.coordinate.latitude), longitude: \(cntLocation.coordinate.longitude)")
    }
    
    
    func LonLatToCity(){
        let geocoder: CLGeocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(currLocation) { (placemarks, error) in
            self.address = String(describing: (placemarks?.first?.name!)!)
            print("地址：\(self.address)")
            print(String(describing: placemarks?.first?.name))
        }
    }
}

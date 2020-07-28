//
//  ViewController.swift
//  TravelYours
//
//  Created by sarath kumar on 27/07/20.
//  Copyright © 2020 sarath kumar. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameTextFiels: UITextField!
    @IBOutlet weak var commandTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.requestWhenInUseAuthorization()
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        let gesterRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gesterRecognizer.minimumPressDuration = 3
        self.mapView.addGestureRecognizer(gesterRecognizer)
    }
    
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.mapView)
            let touchCoordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            chosenLatitude = touchCoordinate.latitude
            chosenLongitude = touchCoordinate.latitude
            
            let annotations = MKPointAnnotation()
            annotations.coordinate = touchCoordinate
            annotations.title = "Your Location"
            annotations.subtitle = "Travel Your Location"
            self.mapView.addAnnotation(annotations)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //MARK:- Action methods
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newplace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        
        newplace.setValue(nameTextFiels.text, forKey: "name")
        newplace.setValue(commandTextField.text, forKey: "command")
        newplace.setValue(UUID(), forKey: "id")
        newplace.setValue(chosenLatitude, forKey: "latitude")
        newplace.setValue(chosenLongitude, forKey: "longitude")
        
        do {
            try context.save()
            print("saved successfully")
        } catch {
            print("place is not saved")
        }
        
    }

}


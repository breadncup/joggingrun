
//
//  ViewController.swift
//  joggingrun
//
//  Created by YOUNGWHAN SONG on 9/14/16.
//  Copyright © 2016 YOUNGWHAN SONG. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

	var locationManager: CLLocationManager = CLLocationManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
//		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
//		locationManager.activityType = .fitness
//		locationManager.distanceFilter = 1  // Movement threshold for new events
		
		//allow location use
		locationManager.requestAlwaysAuthorization()
		
		let myas = CLLocationManager.authorizationStatus()
		switch myas {
		case CLAuthorizationStatus.restricted:
			print("Restricted Access to location")
		case CLAuthorizationStatus.denied:
			print("User denied access to location")
		case CLAuthorizationStatus.notDetermined:
			print("Status not determined")
		case CLAuthorizationStatus.authorizedAlways:
			print("authorizedAlways")
		default:
			print("Allowed to location Access")
		}
		
		print("did load")
		print(locationManager)
		
		//get current user location for startup
		// if CLLocationManager.locationServicesEnabled() {
//		locationManager.startMonitoringSignificantLocationChanges()
		locationManager.startUpdatingLocation()
		
		if CLLocationManager.locationServicesEnabled() == true {
			print("locationServicesEnabled")
		}
		if CLLocationManager.headingAvailable() == true {
			print("headingAvailable")
		}
		if CLLocationManager.significantLocationChangeMonitoringAvailable() == true {
			print("significantLocationChangeMonitoringAvailable")
		}
		//		if CLLocationManager.isMonitoringAvailable() == true {
		//			print("isMonitoringAvailable")
		//		}
		if CLLocationManager.isRangingAvailable() == true {
			print("isRangingAvailable")
		}
		//		if CLLocationManager.isMonitoringAvailable() == true {
		//			print("isMonitoringAvailable")
		//		}
		//		mylocationManager.requestLocation()
		// }
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
		print("didReceiveMemoryWarning")
	}
	
	@IBAction func btnAction(_ sender: UIButton) {
		locationManager.requestLocation()
	}
	
	//location manager
//	lazy var mylocationManager: CLLocationManager = {
//		var _locationManager = CLLocationManager()
//		_locationManager.delegate = self
//		_locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//		_locationManager.activityType = .fitness
//		_locationManager.distanceFilter = 1  // Movement threshold for new events
//		//  _locationManager.allowsBackgroundLocationUpdates = true // allow in background
//		
//		return _locationManager
//	}()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	func locationManager(_ manager: CLLocationManager, didChange status: CLAuthorizationStatus) {
		print("didChangeAuthorizationStatus")
		switch status {
		case CLAuthorizationStatus.restricted:
			print("Restricted Access to location")
		case CLAuthorizationStatus.denied:
			print("User denied access to location")
		case CLAuthorizationStatus.notDetermined:
			print("Status not determined")
		default:
			print("Allowed to location Access")
		}
		
		if case CLAuthorizationStatus.authorizedAlways = status {
			manager.startUpdatingLocation()
		}
	}
	
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		print("didChangeAuthorizationStatus")
		switch status {
		case CLAuthorizationStatus.restricted:
			print("Restricted Access to location")
		case CLAuthorizationStatus.denied:
			print("User denied access to location")
		case CLAuthorizationStatus.notDetermined:
			print("Status not determined")
		default:
			print("Allowed to location Access")
		}
		
		if case CLAuthorizationStatus.authorizedAlways = status {
			manager.startUpdatingLocation()
		}
	}
	
//	func locationManager(_ manager: CLLocationManager, didUpdate locations: [CLLocation]) {
//		for location in locations {
//			
//			print("**********************")
//			print("Long \(location.coordinate.longitude)")
//			print("Lati \(location.coordinate.latitude)")
//			print("Alt \(location.altitude)")
//			print("Sped \(location.speed)")
//			print("Accu \(location.horizontalAccuracy)")
//			
//			print("**********************")
//			
//			
//		}
//	}
	
	func locationManager(_ manager: CLLocationManager, didUpdate locations: [CLLocation]) {
		
		for location in locations {
			
			print("**********************")
			print("Long \(location.coordinate.longitude)")
			print("Lati \(location.coordinate.latitude)")
			print("Alt \(location.altitude)")
			print("Sped \(location.speed)")
			print("Accu \(location.horizontalAccuracy)")
			
			print("**********************")
			
			
		}
	}

}

//// MARK: - CLLocationManagerDelegate
//extension ViewController: CLLocationManagerDelegate {
//	
//}

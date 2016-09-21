//
//  joggingViewController.swift
//  joggingrun
//
//  Created by YOUNGWHAN SONG on 9/14/16.
//  Copyright © 2016 YOUNGWHAN SONG. All rights reserved.
//

import UIKit
import CoreLocation

class joggingViewController: UIViewController,CLLocationManagerDelegate {
	
	@IBOutlet weak var distanceValue: UILabel!
	
	var run1ImageView: UIImageView
	var fPreviousLocation: CLLocationDistance = 0
	
	lazy var locationManager: CLLocationManager = {
		let m = CLLocationManager()
		m.delegate = self
		m.desiredAccuracy = kCLLocationAccuracyBestForNavigation
		m.activityType = .fitness
//		m.distanceFilter = 10
//		m.allowsBackgroundLocationUpdates = true
		return m
	}()
	
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
	
	func locationManager(manager: CLLocationManager, didUpdate locations: [CLLocation]) {
		let curLocation = locations.last
		let currentLocation : CLLocationDistance = (curLocation?.distance(from: curLocation!))!
		if ( fPreviousLocation != 0 ) {
			let distance = currentLocation - fPreviousLocation
			distanceValue.text = String(distance)
		}
	}
	
	func locationManager(manager: CLLocationManager,
	                     didFailWithError error: NSError) {
		//TODO: handle the error
		print("Error")
	}
	
	required init?(coder aDecoder: NSCoder) {
		let run1FileName = "run1.png"
		let run2FileName = "run2.png"
		
		let run1Image = UIImage(named: run1FileName)!
		let run2Image = UIImage(named: run2FileName)!
		
		let imgListArray : [UIImage] = [run1Image, run2Image]
		
		run1ImageView = UIImageView.init()
		run1ImageView.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
		run1ImageView.animationImages = imgListArray
		run1ImageView.animationDuration = 1.0

		super.init(coder: aDecoder)
		
//		locationManager.requestAlwaysAuthorization()
	}
	
	@IBAction func startAction(_ sender: UIButton) {
		run1ImageView.startAnimating()
		locationManager.startUpdatingLocation()
		
		if CLLocationManager.locationServicesEnabled() {
			print("yes")
			locationManager.startMonitoringSignificantLocationChanges()
			locationManager.startUpdatingLocation()
		}
		else {
			print("no")
		}
	}
	
	@IBAction func stopAction(_ sender: UIButton) {
		run1ImageView.stopAnimating()
		locationManager.stopUpdatingLocation()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		//allow location use
		locationManager.requestAlwaysAuthorization()
		
		print("did load")
		print(locationManager)
		
		//get current user location for startup
		// if CLLocationManager.locationServicesEnabled() {
		locationManager.startUpdatingLocation()
		// }
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(run1ImageView)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear( animated )
	}
}


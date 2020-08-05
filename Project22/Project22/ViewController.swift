//
//  ViewController.swift
//  Project22
//
//  Created by Leonardo Diaz on 8/3/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    //MARK: - Outlet
    @IBOutlet weak var distanceReading: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var locationManager: CLLocationManager?
    var beaconDetected = false
    var beaconUUID: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        nameLabel.text = "UNKNOWN BEACON"
        setupCircle()
    }
    
    func setupCircle(){
        circleView.backgroundColor = .gray
        circleView.layer.cornerRadius = 128
        circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning(){
        // Challenge 2
        addBeacon(uuid: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", major: 123, minor: 456, name: "Apple Beacon")
        addBeacon(uuid: "65A6E2E2-B810-4A12-A178-37413A75B25B", major: 123, minor: 456, name: "First Random")
        addBeacon(uuid: "C6265244-04FA-4CBA-9456-2BFAA40AFA73", major: 123, minor: 456, name: "Second Random")
    }
    
    func addBeacon(uuid: String, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, name: String){
        let uuid = UUID(uuidString: uuid)!
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: CLBeaconIdentityConstraint(uuid: uuid, major: major, minor: minor), identifier: name)
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid, major: major, minor: minor))
    }
    
    // Challenge 1
    func beaconAlert(){
        if !beaconDetected {
            let alertController = UIAlertController(title: "Beacon Detected", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            beaconDetected.toggle()
            present(alertController, animated: true)
        }
    }
    
    func update(distance: CLProximity, name: String) {
        UIView.animate(withDuration: 1) { [weak self] in
            self?.nameLabel.text = name
            switch distance {
            case .far:
                self?.circleView.backgroundColor = .blue
                // Challenge 3
                self?.circleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self?.distanceReading.text = "FAR"
                
            case .near:
                self?.circleView.backgroundColor = .orange
                self?.circleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self?.distanceReading.text = "NEAR"
                
            case .immediate:
                self?.circleView.backgroundColor = .red
                self?.circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self?.distanceReading.text = "RIGHT HERE"
                
            default:
                self?.circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self?.circleView.backgroundColor = .gray
                self?.distanceReading.text = "UNKNOWN"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            
            if beaconUUID == nil {
                beaconUUID = region.uuid
            }
            
            guard beaconUUID == region.uuid else { return }
            
            update(distance: beacon.proximity, name: region.identifier)
            beaconAlert()
        } else {
            guard beaconUUID == region.uuid else { return }
            beaconUUID = nil
            
            update(distance: .unknown, name: region.identifier)
        }
    }
    
}

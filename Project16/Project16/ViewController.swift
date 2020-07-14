//
//  ViewController.swift
//  Project16
//
//  Created by Leonardo Diaz on 7/13/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "map.fill"), style: .done, target: self, action: #selector(viewMapOptions))
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2DMake(51.507222, -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2DMake(59.95, 10.75), info: "Founded over 1000 years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2DMake(48.8567, 2.3508), info: "Often called the city of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2DMake(41.9, 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2DMake(38.895111, -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    // Challenge 2
    @objc func viewMapOptions(){
        let alertController = UIAlertController(title: "Map View Types", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { [weak self] (_) in
            self?.mapView.mapType = .hybrid
        }))
        alertController.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { [weak self] (_) in
            self?.mapView.mapType = .satellite
        }))
        alertController.addAction(UIAlertAction(title: "Standard", style: .default, handler: { [weak self] (_) in
            self?.mapView.mapType = .standard
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        // First time loading annotation
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            // After annotation is loaded once
            annotationView?.annotation = annotation
        }
        // Challenge 1
//        if let annotationPin = annotationView as? MKPinAnnotationView {
//            annotationPin.pinTintColor = .systemTeal
//        }
        annotationView?.pinTintColor = .systemTeal
        annotationView?.tintColor = .systemTeal
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
    
        let placeName = capital.title
        let placeInfo = capital.info
        
        let alertController = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        alertController.addAction(UIAlertAction(title: "Wikipedia", style: .default, handler: { [weak self] (_) in
            guard let url = URL(string: capital.baseURL) else { return }
            let finalURL = url.appendingPathComponent(capital.title ?? "")
            self?.viewWikipedia(url: finalURL)
        }))
        present(alertController, animated: true)
    }
    
    func viewWikipedia(url: URL){
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "wikiDetail") as? DetailsViewController {
            destinationVC.capitalURL = url
            navigationController?.pushViewController(destinationVC, animated: true)
        }
        
    }
}


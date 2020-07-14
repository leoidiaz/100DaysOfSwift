//
//  Capital.swift
//  Project16
//
//  Created by Leonardo Diaz on 7/13/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var baseURL = "https://en.wikipedia.org/wiki"

    init(title: String, coordinate: CLLocationCoordinate2D, info: String){
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }

}

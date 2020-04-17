//
//  Person.swift
//  Project10
//
//  Created by Leonardo Diaz on 4/6/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String){
        self.name = name
        self.image = image
    }
}

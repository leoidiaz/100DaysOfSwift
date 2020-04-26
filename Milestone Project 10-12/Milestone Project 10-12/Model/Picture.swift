//
//  Picture.swift
//  Milestone Project 10-12
//
//  Created by Leonardo Diaz on 4/26/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class Picture: Codable {
    var name: String
    var caption: String?
    var picture: String
    
    init(name: String, caption: String?, picture: String) {
        self.name = name
        self.caption = caption
        self.picture = picture
    }
}

extension Picture: Equatable {
    static func == (lhs: Picture, rhs: Picture) -> Bool {
        return lhs.caption == rhs.caption && lhs.name == rhs.name && lhs.picture == rhs.picture
    }  
}

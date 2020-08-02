//
//  Note.swift
//  MilestoneProject19-21
//
//  Created by Leonardo Diaz on 8/1/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import Foundation

class Note: Codable {
    var noteInfo: String
    var dateCreated: Date
    
    init(noteInfo: String, dateCreated: Date = Date()) {
        self.noteInfo = noteInfo
        self.dateCreated = dateCreated
    }
    
}

extension Note:Equatable {
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.noteInfo == rhs.noteInfo && lhs.dateCreated == rhs.dateCreated
    }
}

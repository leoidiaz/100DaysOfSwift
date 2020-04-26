//
//  PhotoController.swift
//  Milestone Project 10-12
//
//  Created by Leonardo Diaz on 4/26/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class PhotoController {
    static let shared = PhotoController()
    var pictures = [Picture]()
    
    
    func create(name: String = "Rename Me", caption: String = "Caption Me", image: String){
        let newPicture = Picture(name: name, caption: caption, picture: image)
        pictures.append(newPicture)
        save()
    }
    
    func update(name: String, caption: String?, picture: Picture){
        picture.name = name
        picture.caption = caption
        save()
    }
    
    func deleteItem(picture: Picture){
        guard let indexPath = pictures.firstIndex(of: picture) else { return }
        pictures.remove(at: indexPath)
         let picturePath = PhotoController.shared.folderPath().appendingPathComponent(picture.picture)
        do {
            try FileManager.default.removeItem(at: picturePath)
        } catch {
            print(error.localizedDescription)
        }
        save()
    }
    
    //MARK: - Persistence
    func filePath() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = url[0].appendingPathComponent("MileStoneProject10_12")
        return fileURL
    }
    
    func folderPath() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    
    func save() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(pictures)
            try data.write(to: filePath())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: filePath())
            let decodedData = try decoder.decode([Picture].self, from: data)
            pictures = decodedData
        } catch {
            print(error.localizedDescription)
        }
    }
}

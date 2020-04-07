//
//  ViewController.swift
//  Project10
//
//  Created by Leonardo Diaz on 4/5/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController  {
    private let reuseIndetifier = "Person"
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    

}

extension ViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIndetifier, for: indexPath) as? PersonCell else { fatalError("Unable to dequeue PersonCell.")}
        let person = people[indexPath.item]
        cell.name.text = person.name
        // get current image path
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        alertControllerOptions(indexPath: indexPath)
    }
    
    // Challenge 1
    //MARK: - Alert Controller Options
    func alertControllerOptions(indexPath: IndexPath){
        let alertController = UIAlertController(title: "Options", message: "Did you want to delete this person or rename?", preferredStyle: .alert)
        let rename = UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            self?.renameController(indexPath: indexPath)
        }
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteItem(indexPath: indexPath)
        }
        
        alertController.addAction(delete)
        alertController.addAction(rename)
        present(alertController, animated: true)
    }
    
    //MARK: - Rename Person
    func renameController(indexPath: IndexPath){
        let person = people[indexPath.item]
        
        let renameController = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        renameController.addTextField()
        
        renameController.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let newName = renameController.textFields?[0].text else { return }
            person.name = newName
            self?.collectionView.reloadData()
        })
        
            renameController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(renameController, animated: true)
    }
    
    //MARK: - Delete Item
    func deleteItem(indexPath: IndexPath){
        people.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
      

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func addNewPerson() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let alertController = UIAlertController(title: "Options", message: "Import from photos or take a new picture", preferredStyle: .alert)
            let photos = UIAlertAction(title: "Photos", style: .default) { [weak self] _ in
                self?.photosPicker()
            }
            let camera = UIAlertAction(title: "Camera", style: .default) { [weak self] _  in
                self?.cameraPicker()
            }
            alertController.addAction(photos)
            alertController.addAction(camera)
            present(alertController, animated: true)
        } else {
            photosPicker()
        }
    }
    
    // Challenge 2
    func photosPicker(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func cameraPicker(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        //  extract the unique identifier as a string data type.
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        // Save image data
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        // Create a new instance with name and image id
        let person = Person(name: "Unkown", image: imageName)
        // append it to people array
        people.append(person)
        collectionView.reloadData()
        
        // Dismiss top most view i.e. imagePicker
        dismiss(animated: true)
    }
    
    // Path to users documents directory
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}


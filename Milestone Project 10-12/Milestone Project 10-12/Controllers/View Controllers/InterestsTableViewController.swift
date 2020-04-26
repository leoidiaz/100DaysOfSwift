//
//  InterestsTableViewController.swift
//  Milestone Project 10-12
//
//  Created by Leonardo Diaz on 4/26/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class InterestsTableViewController: UITableViewController {
    //MARK: - Properties
    private let cellID = "pictureCell"
    var edit = false
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    //MARK: - Actions
    
    @objc func editTapped(){
        edit.toggle()
        navigationItem.leftBarButtonItem?.title = edit ? "Cancel" : "Edit"
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PhotoController.shared.pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let picture = PhotoController.shared.pictures[indexPath.row]
        let picturePath = PhotoController.shared.folderPath().appendingPathComponent(picture.picture)
        cell.imageView?.image = UIImage(contentsOfFile: picturePath.path)
        cell.textLabel?.text = picture.name
        cell.detailTextLabel?.text = picture.caption
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if edit {
            renameController(index: indexPath)
            editTapped()
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            if let detailVC = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
                let picture = PhotoController.shared.pictures[indexPath.row]
                detailVC.picture = picture
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let picture = PhotoController.shared.pictures[indexPath.row]
            PhotoController.shared.deleteItem(picture: picture)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //MARK: - Helper Function
    func renameController(index: IndexPath) {
        let picture = PhotoController.shared.pictures[index.row]
        let alertController = UIAlertController(title: "Options", message: "Rename Title or Captions?", preferredStyle: .alert)
        alertController.addTextField { (titleText) in
            titleText.text = picture.name
            titleText.placeholder = "Enter a spiffy title here"
        }
        alertController.addTextField { (caption) in
            caption.text = picture.caption
            caption.placeholder = "Enter a snazzy caption here"
        }
        
        let dismiss = UIAlertAction(title: "Cancel", style: .cancel)
        let rename = UIAlertAction(title: "Rename", style: .default) { (_) in
            guard let title = alertController.textFields?[0].text, !title.isEmpty else { return }
            PhotoController.shared.update(name: title, caption: alertController.textFields?[1].text, picture: picture)
            self.tableView.reloadData()
        }
        alertController.addAction(dismiss)
        alertController.addAction(rename)
        
        //        tableView.reloadData()
        present(alertController, animated: true)
    }
    
    private func updateView(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add
            , target: self, action: #selector(addNewPhoto))
        PhotoController.shared.load()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        print(PhotoController.shared.filePath())
        navigationItem.leftBarButtonItem?.tintColor = .brown
        navigationItem.rightBarButtonItem?.tintColor = .brown
    }
    
}

extension InterestsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - PhotoPicker
    @objc func addNewPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let alertController = UIAlertController(title: "Options", message: "Import from photos or take a new picture", preferredStyle: .alert)
            let photos = UIAlertAction(title: "Photos", style: .default) { [weak self] _ in
                self?.photosPicker()
            }
            let camera = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                self?.cameraPicker()
            }
            alertController.addAction(photos)
            alertController.addAction(camera)
            present(alertController, animated: true)
        } else {
            photosPicker()
        }
    }
    // TODO - Combine in an condition statement
    func photosPicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func cameraPicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = PhotoController.shared.folderPath().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        PhotoController.shared.create(image: imageName)
        tableView.reloadData()
        dismiss(animated: true)
    }
}

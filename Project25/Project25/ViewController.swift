//
//  ViewController.swift
//  Project25
//
//  Created by Leonardo Diaz on 8/14/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//
import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    //MARK: - Properties
    var images = [UIImage]()
    private var cellTag = 1000
    private var serviceType = "hws-project25"
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Selfie Share"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        
        mcSession = MCSession(peer: peerID , securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(cellTag) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        return cell
    }
    
    
    //MARK: - Helper Methods
    @objc func showConnectionPrompt() {
        let alertController = UIAlertController(title: "Coonect to others", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        alertController.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: serviceType, session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    //MARK: - MC Delegate Methods
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .connected:
            print("Connected: \(peerID.displayName)")
        @unknown default:
            print("Unkown state received: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data)  {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
    }
}


//MARK: - Image Picker Delegates
extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    let alertController = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
                    present(alertController, animated: true)
                }
            }
        }
    }
    
    @objc func importPicture(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}


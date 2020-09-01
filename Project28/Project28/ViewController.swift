//
//  ViewController.swift
//  Project28
//
//  Created by Leonardo Diaz on 8/31/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//
import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var secretTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nothing to see here"
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboad), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboad), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "🔑", style: .plain, target: self, action: #selector(setPassword))
    }
    
    // Challenge 1
    @objc func doneButtonTapped(){
        saveSecretMessage()
        navigationItem.rightBarButtonItem = nil
    }
    // Challenge 2
    @objc func setPassword(){
        let alertController = UIAlertController(title: "Set a password", message: nil, preferredStyle: .alert)
        if KeychainWrapper.standard.string(forKey: "passwordKey") == nil{
            alertController.addTextField { (textField) in
                textField.placeholder = "Set a new password"
            }
        } else {
            alertController.addTextField { (textField) in
                textField.placeholder = "Current password"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Set a new password"
            }
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Set Password", style: .default, handler: { [weak self] (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else { self?.showAlert(title: "Oof", message: "Textfield cannot be empty"); return }
            guard let secondText = alertController.textFields?.last?.text, !secondText.isEmpty else { self?.showAlert(title: "Oof", message: "Textfield cannot be empty"); return }
            
            if KeychainWrapper.standard.string(forKey: "passwordKey") == nil {
                KeychainWrapper.standard.set(text, forKey: "passwordKey")
                self?.showAlert(title: "New password set", message: "Hope you wrote it down.")
            } else {
                if text == secondText {
                    KeychainWrapper.standard.set(secondText, forKey: "passwordKey")
                    self?.showAlert(title: "Password reset", message: "Hope you wrote it down.")
                } else {
                    self?.showAlert(title: "Oof", message: "Passwords do not match")
                }
            }
        }))
        present(alertController, animated: true)
    }
    
    @objc func adjustForKeyboad(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secretTextView.contentInset = .zero
        } else {
            secretTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secretTextView.scrollIndicatorInsets = secretTextView.contentInset
        
        let selectedRange = secretTextView.selectedRange
        secretTextView.scrollRangeToVisible(selectedRange)
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        if KeychainWrapper.standard.string(forKey: "passwordKey") != nil {
                            self?.showPasswordUnlock()
                        } else {
                            self?.showAlert(title: "Authentication", message: "You could not be verified; please try again or set a password.")
                        }
                    }
                }
            }
        } else {
            if KeychainWrapper.standard.string(forKey: "passwordKey") != nil {
                showPasswordUnlock()
            } else {
                showAlert(title: "Biometry unavailable", message: "Your device is not configured for biometric authenication.")
            }
        }
    }
    
    func unlockSecretMessage(){
        secretTextView.isHidden = false
        title = "Secret Stuff!"
        
        secretTextView.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
        // Challenge 1
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
    }
    // Challenge 2
    @objc func saveSecretMessage(){
        guard secretTextView.isHidden == false else { return }
        KeychainWrapper.standard.set(secretTextView.text, forKey: "SecretMessage")
        secretTextView.resignFirstResponder()
        secretTextView.isHidden = true
        title = "Nothing to see here"
    }
}
    //MARK: - Alert Controller Extensions
extension ViewController {
    func showAlert(title: String, message: String?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alertController, animated: true)
    }
    
    func showPasswordUnlock(){
        let alertController = UIAlertController(title: "Type in password", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Current Password"
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Log In", style: .default, handler: { [weak self](_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else { self?.showAlert(title: "Oof", message: "Textfield cannot be empty"); return }
            DispatchQueue.main.async {
                if text == KeychainWrapper.standard.string(forKey: "passwordKey") {
                    self?.unlockSecretMessage()
                } else {
                    self?.showAlert(title: "Oof", message: "Password does not match")
                }
            }
        }))
        present(alertController, animated: true)
    }
}

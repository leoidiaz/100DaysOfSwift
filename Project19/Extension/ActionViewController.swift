//
//  ActionViewController.swift
//  Extension
//
//  Created by Leonardo Diaz on 7/24/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol ScriptDelegate: class {
    func loadSelectedScript(scriptString: String)
    func deleteSelectedScript(scriptString: String)
}

class ActionViewController: UIViewController {

    @IBOutlet weak var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    var userDefaults: UserDefaults!
    
    var userScripts = [String: String]()
    
    var identifier = "customSafariScripts"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDefaults = UserDefaults.standard
        userScripts = userDefaults.dictionary(forKey: identifier) as? [String : String] ?? [:]
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        let loadButton = UIBarButtonItem(title: "Load", style: .plain, target: self, action: #selector(load))
        navigationController?.isToolbarHidden = false
        toolbarItems = [saveButton, loadButton]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Presets", style: .done, target: self, action: #selector(alertOptions))
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, err) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        guard let pageURL = self?.pageURL else { return }
                        guard let urlHost = URL(string: pageURL)?.host else { return }
                        guard let dict = self?.userScripts[urlHost] else { return }
                        self?.script.text = dict
                    }
                }
            }
        }
        
    }

    @IBAction func done() {
       let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript" : script.text as String]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey : argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
        
        guard let urlHost = URL(string: pageURL)?.host else { return }
        guard !script.text.isEmpty else { return }
        print(urlHost)
        userScripts[urlHost] = script.text
        userDefaults.set(userScripts, forKey: identifier)
    }

    @objc func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    // Challenge 1
    @objc func alertOptions(){
        let alertController = UIAlertController(title: "Preset Scripts", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Title Alert", style: .default, handler: { [weak self](_) in
            self?.script.text = "alert(document.title);"
            //Fill and Exit
            self?.done()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    // Challenge 2
    @objc func save(){
        let alertController = UIAlertController(title: "Save Script", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Name of Script"
        }
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] (_) in
            guard let textField = alertController.textFields?.first?.text, !textField.isEmpty else { print("Name can not be left empty") ; return }
            guard let scriptText = self?.script.text, !scriptText.isEmpty else { print("There is no script to save") ; return }
            self?.userScripts[textField] = scriptText
            self?.userDefaults.set(self?.userScripts, forKey: self?.identifier ?? "customSafariScripts")
            self?.userDefaults.set(scriptText, forKey: textField)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    @objc func load(){
        let scriptTableView = ScriptsTableViewController()
        var scripts = [Script]()
        
        if !userScripts.isEmpty{
            userScripts.forEach({
                let newScript = Script(name: $0.key, script: $0.value)
                scripts.append(newScript)
            })
        }
        scriptTableView.scripts = scripts
        scriptTableView.delegate = self
        navigationController?.pushViewController(scriptTableView, animated: true)
    }
    
}

extension ActionViewController: ScriptDelegate {
    func loadSelectedScript(scriptString: String) {
        script.text = scriptString
    }
    
    func deleteSelectedScript(scriptString: String) {
        var dictionary = userDefaults.dictionary(forKey: identifier)
        dictionary?.removeValue(forKey: scriptString)
        userScripts.removeValue(forKey: scriptString)
    }
}

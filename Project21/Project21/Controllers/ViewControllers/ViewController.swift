//
//  ViewController.swift
//  Project21
//
//  Created by Leonardo Diaz on 7/30/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))

    }

    @objc func registerLocal(){
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    @objc func scheduleLocal(){
        registerCategories()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the mouse."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData" : "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    // Challenge 2
    func scheduleLater(){
        registerCategories()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the mouse."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData" : "fizzbuzz"]
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    
    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let joke = UNNotificationAction(identifier: "joke", title: "what's up with airplane food?", options: .foreground)
        let remindLater = UNNotificationAction(identifier: "later", title: "Remind me later", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [remindLater, show, joke], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data receieved: \(customData)")
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Default identifier")
                //Challenge 2
            case "later":
                scheduleLater()
                showAlert(title: "Snoozed", message: "Reminder has been snoozed for 24 hours")
            case "show":
                showAlert(title: "Show More", message: customData)
                // Challenge 1
            case "joke":
                showAlert(title: "Joke", message: "✈️")
            default:
                break
            }
        }
        completionHandler()
    }
    
    func showAlert(title: String, message: String?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alertController, animated: true)
    }
}

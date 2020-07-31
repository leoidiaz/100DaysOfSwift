//
//  AppDelegate.swift
//  Project2
//
//  Created by Leonardo Diaz on 3/10/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let userNotifcation = UNNotifications()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let current = UNUserNotificationCenter.current()
        current.delegate = userNotifcation
        
        current.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            current.getPendingNotificationRequests(completionHandler: {[weak self] (requests) in
                if requests.isEmpty {
                    self?.scheduleLocal()
                } else {
                    print(requests)
                    return
                }
            })
            
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //MARK: - Challenge 3
    func registerCategories(){
        let show = UNNotificationAction(identifier: "show", title: "Play!", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func scheduleLocal(){
            registerCategories()
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()

            let content = UNMutableNotificationContent()
            
            content.title = "Time to practice some countries!"
            content.body = "Have you played today?"
            content.categoryIdentifier = "alarm"
            content.userInfo = ["customData" : "fizzbuzz"]
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 11
            dateComponents.minute = 00
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
    
}


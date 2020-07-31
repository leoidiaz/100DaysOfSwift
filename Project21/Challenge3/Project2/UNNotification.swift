//
//  UNNotification.swift
//  Project2
//
//  Created by Leonardo Diaz on 7/31/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class UNNotifications: NSObject, UNUserNotificationCenterDelegate {

    //MARK: - Present notification while playing game
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data receieved: \(customData)")
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Default identifier")
            case "show":
                print("Let's Play Pressed")
            default:
                break
            }
        }
        completionHandler()
    }
}

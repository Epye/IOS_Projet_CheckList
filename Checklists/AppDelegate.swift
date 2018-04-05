//
//  AppDelegate.swift
//  Checklists
//
//  Created by iem on 01/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        /*let content = UNMutableNotificationContent()
        content.title = "HELLO DELINE"
        content.body = "Say hello to Deline"
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let identifier = "DELINE"
        let request = UNNotificationRequest(identifier: identifier,
                                                    content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            print("DONE")
        })*/
        
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        DataModel.sharedInstance.saveCheckList()
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}


//
//  CheckListItem.swift
//  Checklists
//
//  Created by iem on 01/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation
import UserNotifications

class CheckListItem : Codable{
    var itemID: Int = 0
    var Text: String = ""
    var Checked: Bool = false
    var dueDate: Date = Date()
    var shouldRemind: Bool = false
 
    init(text: String, checked: Bool = false, dueDate: Date = Date(), shouldRemind: Bool = false) {
        self.Text = text
        self.Checked = checked
        self.dueDate = dueDate
        self.shouldRemind = shouldRemind
        self.itemID = Preference.sharedInstance.nextCheckListItemID()
    }
    
    init(text: String, checked: Bool = false, dueDate: Date = Date(), shouldRemind: Bool = false, itemID: Int) {
        self.Text = text
        self.Checked = checked
        self.dueDate = dueDate
        self.shouldRemind = shouldRemind
        self.itemID = itemID
    }
    
    func toggleChecked(){
        self.Checked = !self.Checked
    }
    
    func scheduleNotification(){
        let center = UNUserNotificationCenter.current()
        
        center.removePendingNotificationRequests(withIdentifiers: [String(itemID)])

        if shouldRemind && dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = Text
            content.body = Text
            content.sound = UNNotificationSound.default()
            
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: dueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            let request = UNNotificationRequest(identifier: String(itemID), content: content, trigger: trigger)

            center.add(request, withCompletionHandler: { (error) in })
        }
    }
}

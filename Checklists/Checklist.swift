//
//  Checklist.swift
//  Checklists
//
//  Created by iem on 29/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class Checklist : Codable{
    var name: String
    var items: Array<CheckListItem>
    var icon: IconAsset
    
    var uncheckedItemsCount: Int {
            return items.filter{ !$0.Checked }.count
        }
    
    init(name: String, list: Array<CheckListItem> = [], icon: IconAsset = .NoIcon) {
        self.name = name
        self.items = list
        self.icon = icon
    }
}

enum IconAsset : String, Codable {
    case Appointments
    case Birthdays
    case Chores
    case Drinks
    case Folder
    case Groceries
    case Inbox
    case NoIcon = "No Icon"
    case Photos
    case Trips
    var image : UIImage {
        return UIImage(named: self.rawValue)!
    }
}

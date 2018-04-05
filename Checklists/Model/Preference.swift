//
//  Preference.swift
//  Checklists
//
//  Created by iem on 05/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation

class Preference {
    static let sharedInstance = Preference()
    
    enum UserDefaultsKey: String {
        case firstLaunch = "firstLaunch"
        case lastCheckListItemID = "lastCheckListItemID"
    }
    
    var firstLaunch: Bool {
        get{
            if UserDefaults.standard.object(forKey: UserDefaultsKey.firstLaunch.rawValue) == nil {
                return true
            } else {
                return UserDefaults.standard.bool(forKey: UserDefaultsKey.firstLaunch.rawValue)
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.firstLaunch.rawValue)
        }
    }
    
    func nextCheckListItemID() -> Int{
        var itemID = UserDefaults.standard.integer(forKey: UserDefaultsKey.lastCheckListItemID.rawValue)
        itemID = itemID + 1
        UserDefaults.standard.set(itemID, forKey: UserDefaultsKey.lastCheckListItemID.rawValue)
        return itemID
    }
}

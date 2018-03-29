//
//  Checklist.swift
//  Checklists
//
//  Created by iem on 29/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation

class Checklist : Codable{
    var name: String
    var items: Array<CheckListItem>
    
    var uncheckedItemsCount: Int {
            return items.filter{ !$0.Checked }.count
        }
    
    init(name: String, list: Array<CheckListItem> = []) {
        self.name = name
        self.items = list
    }
}

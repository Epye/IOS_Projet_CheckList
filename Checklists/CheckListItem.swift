//
//  CheckListItem.swift
//  Checklists
//
//  Created by iem on 01/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation

class CheckListItem : Codable{
    var Text: String = ""
    var Checked: Bool = false
 
    init(text: String, checked: Bool = false) {
        self.Text = text
        self.Checked = checked
    }
    
    func toggleChecked(){
        self.Checked = !self.Checked
    }
}

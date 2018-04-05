//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by iem on 29/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation


import UIKit

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    
    var delegate: ListDetailViewControllerDelegate!
    var itemToEdit: Checklist!
    var icon: IconAsset = IconAsset.Folder
    
    @IBOutlet weak var textFieldScreen: UITextField!
    
    @IBOutlet weak var imageViewDetail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViewDetail.image = icon.image
        
        if let edit = itemToEdit {
            self.navigationItem.title = "Edit Checklist"
            textFieldScreen.text = edit.name
            imageViewDetail.image = edit.icon.image
            self.icon = edit.icon
        }
    }
    
    @IBAction func cancel() {
        delegate.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = textFieldScreen.text {
            if let edit = itemToEdit {
                itemToEdit.name = item
                itemToEdit.icon = self.icon
                delegate.listDetailViewController(self, didFinishEditingItem: itemToEdit)
            }else {
                delegate.listDetailViewController(self, didFinishAddingItem: Checklist(name: item, icon: self.icon))
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editIcon"{
            if let dest = segue.destination as? IconPickerViewController {
                dest.delegate = self
            }
        }
    }
    
    func iconChange(newIcon: IconAsset){
        if let edit = itemToEdit, edit.icon != newIcon {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        
        self.icon = newIcon
        self.imageViewDetail.image = self.icon.image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textFieldScreen.delegate = self
        textFieldScreen.becomeFirstResponder()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        if let edit = itemToEdit, edit.icon != self.icon {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else if !(textFieldScreen.text?.isEmpty)! && itemToEdit == nil {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
            if newString.isEmpty {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            } else if let edit = itemToEdit, newString == edit.name {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            return true
        }
        return false
    }
}

protocol ListDetailViewControllerDelegate : class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAddingItem item: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingItem item: Checklist)
}

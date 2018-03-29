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
    
    @IBOutlet weak var textFieldScreen: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let edit = itemToEdit {
            self.navigationItem.title = "Edit Checklist"
            textFieldScreen.text = edit.name
        }
    }
    
    @IBAction func cancel() {
        delegate.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = textFieldScreen.text {
            if let edit = itemToEdit {
                itemToEdit.name = item
                delegate.listDetailViewController(self, didFinishEditingItem: itemToEdit)
            }else {
                delegate.listDetailViewController(self, didFinishAddingItem: Checklist(name: item))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textFieldScreen.delegate = self
        textFieldScreen.becomeFirstResponder()
        if itemToEdit == nil{
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
            if newString.isEmpty {
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

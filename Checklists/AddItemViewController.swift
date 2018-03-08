//
//  AddItemViewController.swift
//  Checklists
//
//  Created by iem on 08/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController, UITextFieldDelegate {

    var delegate: AddItemViewControllerDelegate!
    var itemToEdit: CheckListItem!
    
    @IBOutlet weak var textFieldScreen: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let edit = itemToEdit {
            self.navigationItem.title = "Edit Item"
            textFieldScreen.text = edit.Text
        }
    }
    
    @IBAction func cancel() {
        delegate.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = textFieldScreen.text {
            if let edit = itemToEdit {
                itemToEdit.Text = item
                delegate.addItemViewController(self, didFinishEditingItem: itemToEdit)
            }else {
                delegate.addItemViewController(self, didFinishAddingItem: CheckListItem(text: item))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textFieldScreen.delegate = self
        textFieldScreen.becomeFirstResponder()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
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

protocol AddItemViewControllerDelegate : class {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController, didFinishAddingItem item: CheckListItem)
    func addItemViewController(_ controller: AddItemViewController, didFinishEditingItem item: CheckListItem)
}


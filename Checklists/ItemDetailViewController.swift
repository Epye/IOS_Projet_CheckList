//
//  AddItemViewController.swift
//  Checklists
//
//  Created by iem on 08/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    var delegate: ItemDetailViewControllerDelegate!
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
        delegate.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = textFieldScreen.text {
            if let edit = itemToEdit {
                itemToEdit.Text = item
                delegate.itemDetailViewController(self, didFinishEditingItem: itemToEdit)
            }else {
                delegate.itemDetailViewController(self, didFinishAddingItem: CheckListItem(text: item))
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

protocol ItemDetailViewControllerDelegate : class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: CheckListItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: CheckListItem)
}


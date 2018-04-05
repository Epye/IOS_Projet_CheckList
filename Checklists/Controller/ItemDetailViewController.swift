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
    var dueDate: Date = Date()
    var isDatePickerVisible: Bool = false
    
    @IBOutlet weak var textFieldScreen: UITextField!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet var datePickerTableViewCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let edit = itemToEdit {
            self.navigationItem.title = "Edit Item"
            textFieldScreen.text = edit.Text
            shouldRemindSwitch.isOn = edit.shouldRemind
            dueDate = edit.dueDate
            updateDueDateLabel()
        }
    }
    
    func updateDueDateLabel(){
        let format = DateFormatter()
        let timeZone = TimeZone(secondsFromGMT: 7200)
        format.dateStyle = .medium
        format.timeStyle = .medium
        format.locale = Locale(identifier: "en_GB")
        format.timeZone = timeZone
        dueDateLabel.text = format.string(from: dueDate)
    }
    
    
    @IBAction func changeSwitch(_ sender: Any) {
        if let edit = itemToEdit {
            if shouldRemindSwitch.isOn != edit.shouldRemind && !(textFieldScreen.text?.isEmpty)! {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            } else if textFieldScreen.text == edit.Text {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }
    
    @IBAction func cancel() {
        delegate.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = textFieldScreen.text {
            if (itemToEdit) != nil {
                itemToEdit.Text = item
                itemToEdit.shouldRemind = shouldRemindSwitch.isOn
                itemToEdit.dueDate = dueDate
                delegate.itemDetailViewController(self, didFinishEditingItem: itemToEdit)
            }else {
                var itemList: CheckListItem
                if shouldRemindSwitch.isOn {
                    itemList = CheckListItem(text: item, checked: false, dueDate: dueDate, shouldRemind: true)
                } else {
                    itemList = CheckListItem(text: item)
                }
                delegate.itemDetailViewController(self, didFinishAddingItem: itemList)
            }
        }
    }
    @IBAction func onValueChanged(_ sender: Any) {
        dueDate = datePicker.date
        updateDueDateLabel()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isDatePickerVisible {
            hideDatePicker()
        }
    }
    
    func showDatePicker() {
        self.view.endEditing(true)
        isDatePickerVisible = true;
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 2, section: 1)], with: .automatic)
        tableView.endUpdates()
    }
    
    func hideDatePicker(){
        isDatePickerVisible = false;
        tableView.deleteRows(at: [IndexPath(row: 2, section: 1)], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = self.tableView(tableView, cellForRowAt: indexPath)
        if cell.reuseIdentifier == "dueDateCell" {
            return indexPath
        }else{
            return nil;
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 && indexPath.section == 1 {
            return datePickerTableViewCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if isDatePickerVisible {
                return 3
            }else {
                return 2
            }
        }else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = self.tableView(tableView, cellForRowAt: indexPath)
        if cell.reuseIdentifier == "datePickerCell" {
            return datePicker.intrinsicContentSize.height + 1
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView(tableView, cellForRowAt: indexPath)
        if cell.reuseIdentifier == "dueDateCell" {
            if isDatePickerVisible {
                hideDatePicker()
            } else {
                showDatePicker()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.row == 2 && indexPath.section == 1 {
            let tmpIndex = IndexPath(row: 0, section: 1)
            return (tableView.cellForRow(at: tmpIndex)?.indentationLevel)!
        } else {
            return super.tableView(tableView, indentationLevelForRowAt: indexPath)
        }
    }
}

protocol ItemDetailViewControllerDelegate : class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: CheckListItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: CheckListItem)
}


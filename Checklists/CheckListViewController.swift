//
//  ViewController.swift
//  Checklists
//
//  Created by iem on 01/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController {
    
    var CheckListItems: Array<CheckListItem> = []
    
    var list: Checklist!
    
    var documentDirectory: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
    
    var dataFileUrl: URL = URL(fileURLWithPath: "")
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        let file = "data.json"
        dataFileUrl = documentDirectory.appendingPathComponent(file)
        self.loadCheckListItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = list.name
    }

    func saveCheckListItems(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(CheckListItems)
            try data.write(to: dataFileUrl)
        } catch {
            
        }
    }
    
    func loadCheckListItems(){
        let decoder = JSONDecoder()
        do {
            let data = try String(contentsOf: dataFileUrl, encoding: .utf8).data(using: .utf8)
            CheckListItems = try decoder.decode([CheckListItem].self, from: data!)
        } catch {
            
        }
    }
    
    func configureCheckMark(for cell: CheckListItemCell, withItem item: CheckListItem){
        if item.Checked {
            cell.labelCheckMark.isHidden = false
        } else {
            cell.labelCheckMark.isHidden = true
        }
    }
    
    func configureText(for cell: CheckListItemCell, withItem item: CheckListItem){
        cell.labelItem.text = item.Text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        CheckListItems[indexPath.row].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        saveCheckListItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.CheckListItems.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        CheckListItems.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        saveCheckListItems()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.CheckListItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListItem", for: indexPath) as! CheckListItemCell
        configureText(for: cell, withItem: item)
        configureCheckMark(for: cell, withItem: item)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItem"{
            if let navVC = segue.destination as? UINavigationController,
                let destVC = navVC.topViewController as? ItemDetailViewController  {
                destVC.delegate = self
            }
        } else if segue.identifier == "editItem"{
            if let navVC = segue.destination as? UINavigationController,
                let destVC = navVC.topViewController as? ItemDetailViewController  {
                let cell = sender as! CheckListItemCell
                destVC.itemToEdit = CheckListItems[(tableView.indexPath(for: cell)?.row)!]
                destVC.delegate = self
            }
        }
    }
}

extension CheckListViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        controller.dismiss(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: CheckListItem) {
        controller.dismiss(animated: true)
        CheckListItems.append(item)
        let index = IndexPath(item: CheckListItems.count-1, section: 0)
        tableView.insertRows(at: [index], with: UITableViewRowAnimation.fade)
        saveCheckListItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: CheckListItem) {
        controller.dismiss(animated: true)
        let index = IndexPath(item: CheckListItems.index(where: {$0 === item})!, section: 0)
        tableView.reloadRows(at: [index], with: UITableViewRowAnimation.fade)
        saveCheckListItems()
    }
}



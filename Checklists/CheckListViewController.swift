//
//  ViewController.swift
//  Checklists
//
//  Created by iem on 01/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController {
    
    var list: Checklist!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = list.name
        self.view.tintColor = UIColor.purple
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
        list.items[indexPath.row].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.items.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        list.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.list.items[indexPath.row]
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
                destVC.itemToEdit = list.items[(tableView.indexPath(for: cell)?.row)!]
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
        list.items.append(item)
        let index = IndexPath(item: list.items.count-1, section: 0)
        tableView.insertRows(at: [index], with: UITableViewRowAnimation.fade)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: CheckListItem) {
        controller.dismiss(animated: true)
        let index = IndexPath(item: list.items.index(where: {$0 === item})!, section: 0)
        tableView.reloadRows(at: [index], with: UITableViewRowAnimation.fade)
    }
}



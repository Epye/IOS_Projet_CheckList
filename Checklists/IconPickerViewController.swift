//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by iem on 29/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class IconPickerViewController: UITableViewController {

    var delegate: ListDetailViewController!
    var listIcon: Array<IconAsset> = [IconAsset.Appointments, IconAsset.Birthdays, IconAsset.Chores, IconAsset.Drinks, IconAsset.Folder, IconAsset.Groceries, IconAsset.Inbox, IconAsset.NoIcon, IconAsset.Photos, IconAsset.Trips]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listIcon.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        cell.textLabel?.text = listIcon[indexPath.row].rawValue
        cell.imageView?.image = listIcon[indexPath.row].image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.iconChange(newIcon: listIcon[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }

}


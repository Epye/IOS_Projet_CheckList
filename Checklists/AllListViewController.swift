import UIKit

class AllListViewController: UITableViewController {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        DataModel.sharedInstance.loadCheckList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.sharedInstance.listCheckList.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        DataModel.sharedInstance.listCheckList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckList", for: indexPath)
        cell.textLabel?.text = DataModel.sharedInstance.listCheckList[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCheckList" {
            if let destVC = segue.destination as? CheckListViewController  {
                let cell = sender as! UITableViewCell
                destVC.list = DataModel.sharedInstance.listCheckList[(tableView.indexPath(for: cell)?.row)!]
            }
        } else if segue.identifier == "addCheckList"{
            if let navVC = segue.destination as? UINavigationController,
                let destVC = navVC.topViewController as? ListDetailViewController  {
                destVC.delegate = self
            }
        } else if segue.identifier == "editCheckList"{
            if let navVC = segue.destination as? UINavigationController,
                let destVC = navVC.topViewController as? ListDetailViewController  {
                let cell = sender as! UITableViewCell
                destVC.itemToEdit = DataModel.sharedInstance.listCheckList[(tableView.indexPath(for: cell)?.row)!]
                destVC.delegate = self
            }
        }
    }
}


extension AllListViewController: ListDetailViewControllerDelegate {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        controller.dismiss(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAddingItem item: Checklist) {
        controller.dismiss(animated: true)
        DataModel.sharedInstance.listCheckList.append(item)
        let index = IndexPath(item: DataModel.sharedInstance.listCheckList.count-1, section: 0)
        tableView.insertRows(at: [index], with: UITableViewRowAnimation.fade)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingItem item: Checklist) {
        controller.dismiss(animated: true)
        let index = IndexPath(item: DataModel.sharedInstance.listCheckList.index(where: {$0 === item})!, section: 0)
        tableView.reloadRows(at: [index], with: UITableViewRowAnimation.fade)
    }
}

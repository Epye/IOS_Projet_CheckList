import UIKit

class AllListViewController: UITableViewController {

    var listCheckList: Array<Checklist> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listCheckList.append(Checklist(name: "liste1"))
        listCheckList.append(Checklist(name: "liste2"))
        listCheckList.append(Checklist(name: "liste3"))
        listCheckList.append(Checklist(name: "liste4"))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCheckList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckList", for: indexPath)
        cell.textLabel?.text = listCheckList[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCheckList" {
            if let destVC = segue.destination as? CheckListViewController  {
                let cell = sender as! UITableViewCell
                destVC.list = listCheckList[(tableView.indexPath(for: cell)?.row)!]
            }
        }
    }
}

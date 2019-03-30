import UIKit

class MyGroupsController: UIViewController {
    @IBOutlet weak var myGroupsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    private var filteredGroups = [Group] ()
    var groups = [Group] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myGroupsTableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filterContentForSearchText(nil)
        myGroupsTableView.reloadData()
    }
    
    @IBAction func showAllGroups(_ sender: Any) {
        performSegue(withIdentifier: "showAllGroups", sender: self)
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            let allGroupsController = segue.source as! AllGroupsController
            if let indexPath = allGroupsController.allGroups.indexPathForSelectedRow {
                
                let group = allGroupsController.groups[indexPath.row]
                
                if !groups.contains {$0.name == group.name} {
                    groups.append(group)
                    myGroupsTableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AllGroupsController {
            vc.isGroupAdded = { group in
                return self.groups.contains(group)
            }
            vc.addGroup = { group in
                if !self.groups.contains(group) {
                    self.groups.append(group)
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String?, scope: String = "All") {
        
        if searchText?.isEmpty ?? true {
            filteredGroups = groups
        } else {
            filteredGroups = groups.filter {$0.name.lowercased().contains(searchText!.lowercased())}
        }
        
        myGroupsTableView.reloadData()
    }

}

extension MyGroupsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsCell
        
        let group = self.filteredGroups[indexPath.row]
        cell.groupName.text = group.name
        cell.groupImage.image = group.image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groupToRemove = filteredGroups[indexPath.row]
            filteredGroups.remove(at: indexPath.row)
            groups = groups.filter {$0 != groupToRemove}
            myGroupsTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension MyGroupsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
}

import UIKit

class AllGroupsController: UIViewController {

    @IBOutlet weak var allGroups: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var addGroup: ((Group) -> Void)?
    var isGroupAdded: ((Group) -> Bool)?
    
    private var initGroups = [Group] ()
    var groups = [Group] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allGroups.dataSource = self
        searchBar.delegate = self
        
//        initGroups = [
//            Group(name: "Developing Microservices", image: UIImage(named: "g1")),
//            Group(name: "iOS Jailbreak/Tweaks", image: UIImage(named: "g2")),
//            Group(name: "Web Design and Development", image: UIImage(named: "g3")),
//            Group(name: "Javascript", image: UIImage(named: "g4")),
//            Group(name: "Game Development", image: UIImage(named: "g5"))
//        ]
        
        filterContentForSearchText(nil)
    }
    
    func filterContentForSearchText(_ searchText: String?, scope: String = "All") {
        
        if searchText?.isEmpty ?? true {
            self.groups = self.initGroups
        } else {
            groups = self.initGroups.filter {$0.name.lowercased().contains(searchText!.lowercased())}
        }
        
        allGroups.reloadData()
    }
}

extension AllGroupsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupsCell", for: indexPath) as! AllGroupsCell
        
        let group = groups[indexPath.row]
        cell.groupName.text = group.name
//        cell.groupImage.image = group.image
        
        // Disable add button if group has been added earlear
        if let isGroupAdded = isGroupAdded {
            if isGroupAdded(group) {
                cell.disableAddButton()
            }
        }
        
        cell.addGroupTapped = { groupName, groupImage in
//            let group = Group(name: groupName, image: groupImage)
//            guard let addGroup = self.addGroup else {
//                return
//            }
//            addGroup(group)
        }
        
        return cell
    }
}

extension AllGroupsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
}

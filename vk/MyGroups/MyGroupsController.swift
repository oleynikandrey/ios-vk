import UIKit

class MyGroupsController: UIViewController {
    @IBOutlet weak var myGroups: UITableView!
    
    var groups = [Group] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myGroups.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myGroups.reloadData()
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            let allGroupsController = segue.source as! AllGroupsController
            if let indexPath = allGroupsController.allGroups.indexPathForSelectedRow {
                
                let group = allGroupsController.groups[indexPath.row]
                
                if !groups.contains {$0.name == group.name} {
                    groups.append(group)
                    myGroups.reloadData()
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

}

extension MyGroupsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsCell
        
        let group = self.groups[indexPath.row]
        cell.groupName.text = group.name
        cell.groupImage.image = group.image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            myGroups.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

import UIKit

class MyFriendsController: UIViewController {
    
    @IBOutlet weak var friendsTable: UITableView!
    
    var friends = [User] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsTable.dataSource = self
        
        friends = [
            User(name: "Friend 1", avatar: UIImage(named: "1")),
            User(name: "Friend 2", avatar: UIImage(named: "2")),
            User(name: "Friend 3", avatar: UIImage(named: "3")),
            User(name: "Friend 4", avatar: UIImage(named: "4")),
            User(name: "Friend 5", avatar: UIImage(named: "5"))
        ]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFriendInfo" {
            if let indexPath = friendsTable.indexPathForSelectedRow {
                let friend = friends[indexPath.row]
                let controller = segue.destination as! FriendInfoController
                controller.friend = friend
            }
        }
    }
}

extension MyFriendsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsCell", for: indexPath) as! MyFriendsCell

        let friend = friends[indexPath.row]
        cell.name.text = friend.name
        cell.avatar.image = friend.avatar

        return cell
    }
    
}

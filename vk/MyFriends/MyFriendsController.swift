import UIKit

class MyFriendsController: UIViewController {
    
    @IBOutlet weak var indexListView: IndexList!
    @IBOutlet weak var friendsTable: UITableView!
    
    var friends = [User] ()
    private var friendsGrouped: [String: [User]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsTable.dataSource = self
        indexListView.delegate = self
        
        friends = [
            User(name: "Rachell Lenton", avatar: UIImage(named: "1")),
            User(name: "Karolyn Higginbotham", avatar: UIImage(named: "2")),
            User(name: "Arie Vadnais", avatar: UIImage(named: "3")),
            User(name: "Toshia Fong", avatar: UIImage(named: "4")),
            User(name: "Yuriko Dellinger", avatar: UIImage(named: "5")),
            User(name: "Verlie Devereux", avatar: UIImage(named: "6")),
            User(name: "Alene Oconnor", avatar: UIImage(named: "7")),
            User(name: "Enriqueta Carlsen", avatar: UIImage(named: "8")),
            User(name: "Franklin Harms", avatar: UIImage(named: "9")),
            User(name: "Eldridge Ferrell", avatar: UIImage(named: "10")),
            User(name: "Kandi Thorman", avatar: UIImage(named: "11")),
            User(name: "Sabrina Rushin", avatar: UIImage(named: "12")),
            User(name: "Julia Duplantis", avatar: UIImage(named: "13")),
            User(name: "Max Kinnaird", avatar: UIImage(named: "14")),
            User(name: "Ayesha Helton", avatar: UIImage(named: "15")),
            User(name: "Burt Chumbley", avatar: UIImage(named: "16")),
            User(name: "Mitchel Marten", avatar: UIImage(named: "17")),
            User(name: "Angeles Lueras", avatar: UIImage(named: "18")),
            User(name: "Oda Spalding", avatar: UIImage(named: "19"))
        ].sorted(by: {$0.name < $1.name})
        
        for friend in friends {
            guard let char = friend.name.first else {
                continue
            }
            let letter = String.init(char)
            if friendsGrouped.keys.contains(letter) {
                friendsGrouped[letter]?.append(friend)
            } else {
                friendsGrouped[letter] = []
                friendsGrouped[letter]?.append(friend)
            }
        }

        //MARK: - Index list
        
        indexListView.letters = friendsGrouped.keys.sorted()
        indexListView.setupView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFriendInfo" {
            if let indexPath = friendsTable.indexPathForSelectedRow {
                let key = getDictKeyByIndex(dict: friendsGrouped, index: indexPath.section)
                let friend = friendsGrouped[key]?[indexPath.row]
                let controller = segue.destination as! FriendInfoController
                controller.friend = friend
            }
        }
    }
}

extension MyFriendsController: UITableViewDataSource {
    private func getDictKeyByIndex(dict: Dictionary<String, Any>, index: Int) -> String {
        return dict.keys.sorted()[index]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return friendsGrouped.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = getDictKeyByIndex(dict: friendsGrouped, index: section)
        return sectionTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = getDictKeyByIndex(dict: friendsGrouped, index: section)
        return friendsGrouped[sectionTitle]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsCell", for: indexPath) as! MyFriendsCell
        cell.avatar.image = nil
        
        let sectionTitle = getDictKeyByIndex(dict: friendsGrouped, index: indexPath.section)
        let sectionFriends = friendsGrouped[sectionTitle]
        
        let friend = sectionFriends![indexPath.row]
        cell.name.text = friend.name
        let avatar = cell.avatar as? AvatarImageView
        avatar?.image = friend.avatar
        
        return cell
    }
    
    
}

extension MyFriendsController: TableSectionSelecter {
    func selectedSection(sectionLetter: String) {
        let sectionIndex = friendsGrouped.keys.sorted().firstIndex(of: sectionLetter)
        let indexPath = IndexPath(row: 0, section: sectionIndex!)
        friendsTable.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}


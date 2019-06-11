import UIKit
import RealmSwift

class MyFriendsController: UIViewController {
    
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var friends = [Friend] ()
    private var initFriends = [Friend] ()
    private var friendsGrouped: [String: [Friend]] = [:]
    
    private var realmFriends: Results<Friend>?
    private var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        searchBar.delegate = self
        
        self.initFriends = VKDao.loadFriendsData()
        
        pairTableAndRealm()

        //MARK: - Look and feel
        friendsTableView.backgroundColor = nil

        //MARK: - Section headers
        //we don't need custom UITableViewHeaderFooterView class here.
        friendsTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "MyFriendsSectionHeader")
        
        //MARK: - Search
        filterContentForSearchText(nil)
    }
    
    func filterContentForSearchText(_ searchText: String?, scope: String = "All") {
        
        if searchText?.isEmpty ?? true {
            friends = Array(realmFriends!)
        } else {
            let query = searchText!.lowercased()
            let predicate = NSPredicate(format: "first_name CONTAINS [cd]%@ OR last_name CONTAINS [cd]%@", query, query)
            friends = Array(realmFriends!.filter(predicate))
        }
        
        friendsGrouped = [:]
        
        for friend in friends {
            guard let char = friend.last_name.first else {
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
        
        friendsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFriendInfo" {
            if let indexPath = friendsTableView.indexPathForSelectedRow {
                let key = getDictKeyByIndex(dict: friendsGrouped, index: indexPath.section)
                let friend = friendsGrouped[key]?[indexPath.row]
                let controller = segue.destination as! FriendInfoController
                controller.friend = friend
            }
        }
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else {
            return
        }
        realmFriends = realm.objects(Friend.self)
        token = realmFriends?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.friendsTableView else {
                return
            }

            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, _, _, _):
                self!.filterContentForSearchText(self!.searchBar.text)
            case .error(let error):
                fatalError("\(error)")
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
        
        let sectionTitle = getDictKeyByIndex(dict: friendsGrouped, index: indexPath.section)
        let sectionFriends = friendsGrouped[sectionTitle]
        
        let friend = sectionFriends![indexPath.row]
        
        cell.name.text = "\(friend.first_name) \(friend.last_name)"
        let avatar = cell.avatar as? AvatarImageView
        avatar?.downloaded(from: friend.photo_uri)
        
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendsGrouped.keys.sorted()
    }
}

extension MyFriendsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MyFriendsSectionHeader")

        header?.backgroundView = UIView()
        header?.backgroundView?.backgroundColor = tableView.backgroundColor?.withAlphaComponent(0.5)

        return header
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}

extension MyFriendsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
}

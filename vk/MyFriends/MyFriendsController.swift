import UIKit

class MyFriendsController: UIViewController {
    
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var friends = [User] ()
    private var initFriends = [User] ()
    private var friendsGrouped: [String: [User]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        searchBar.delegate = self
        
        initFriends = [
            User(name: "Rachell Lenton", avatars: [UIImage(named: "1"), UIImage(named: "1-1")]),
            User(name: "Karolyn Higginbotham", avatars: [UIImage(named: "2"), UIImage(named: "2-2")]),
            User(name: "Arie Vadnais", avatars: [UIImage(named: "3"), UIImage(named: "3-3")]),
            User(name: "Toshia Fong", avatars: [UIImage(named: "4"), UIImage(named: "4-4")]),
            User(name: "Yuriko Dellinger", avatars: [UIImage(named: "5"), UIImage(named: "5-5")]),
            User(name: "Verlie Devereux", avatars: [UIImage(named: "6"), UIImage(named: "6-6")]),
            User(name: "Alene Oconnor", avatars: [UIImage(named: "7"), UIImage(named: "7-7")]),
            User(name: "Enriqueta Carlsen", avatars: [UIImage(named: "8"), UIImage(named: "8-8")]),
            User(name: "Franklin Harms", avatars: [UIImage(named: "9"), UIImage(named: "9-9")]),
            User(name: "Eldridge Ferrell", avatars: [UIImage(named: "10"), UIImage(named: "10-10")]),
            User(name: "Kandi Thorman", avatars: [UIImage(named: "11"), UIImage(named: "11-11")]),
            User(name: "Sabrina Rushin", avatars: [UIImage(named: "12"), UIImage(named: "12-12")]),
            User(name: "Julia Duplantis", avatars: [UIImage(named: "13"), UIImage(named: "13-13")]),
            User(name: "Max Kinnaird", avatars: [UIImage(named: "14"), UIImage(named: "14-14")]),
            User(name: "Ayesha Helton", avatars: [UIImage(named: "15"), UIImage(named: "15-15")]),
            User(name: "Burt Chumbley", avatars: [UIImage(named: "16"), UIImage(named: "16-16")]),
            User(name: "Mitchel Marten", avatars: [UIImage(named: "17"), UIImage(named: "17-17")]),
            User(name: "Angeles Lueras", avatars: [UIImage(named: "18"), UIImage(named: "18-18")]),
            User(name: "Oda Spalding", avatars: [UIImage(named: "19"), UIImage(named: "19-19")])
        ].sorted(by: {$0.name < $1.name})
        
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
            friends = initFriends
        } else {
            friends = initFriends.filter {$0.name.lowercased().contains(searchText!.lowercased())}
        }
        
        friendsGrouped = [:]
        
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
        avatar?.image = friend.avatars[0]
        
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

import UIKit

class FriendInfoController: UIViewController {

    @IBOutlet weak var friendInfo: UICollectionView!
    
    var friend: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendInfo.dataSource = self
    }
}

extension FriendInfoController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = friendInfo.dequeueReusableCell(withReuseIdentifier: "FriendInfoCell", for: indexPath) as! FriendInfoCell
        
        cell.avatar.image = friend?.avatar
        
        return cell
    }
    
    
}

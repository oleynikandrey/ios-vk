import UIKit

class FriendInfoController: UIViewController {

    @IBOutlet weak var friendInfo: UICollectionView!
    
    var friend: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendInfo.dataSource = self
        friendInfo.delegate = self
    }
    
    func animateFriendInfoCellImage(cell: FriendInfoCell) {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.97
        animation.toValue = 1
        animation.stiffness = 700
        animation.mass = 10
        animation.duration = 0.5
        animation.beginTime = CACurrentMediaTime()
        
        cell.avatar.layer.add(animation, forKey: nil)
    }
}

extension FriendInfoController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = friendInfo.dequeueReusableCell(withReuseIdentifier: "FriendInfoCell", for: indexPath) as! FriendInfoCell
        
        let avatar = cell.avatar as? AvatarImageView
        avatar?.image = friend?.avatar
        
        return cell
    }
}

extension FriendInfoController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FriendInfoCell else {
            return
        }
        animateFriendInfoCellImage(cell: cell)
    }
}

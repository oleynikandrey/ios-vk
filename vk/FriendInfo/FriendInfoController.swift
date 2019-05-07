import UIKit

class FriendInfoController: UIViewController {

    @IBOutlet weak var friendInfo: UICollectionView!
    
    var friend: User?
    var imageIndex = 0
    
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
        
        cell.delegate = self
        
        let avatar = cell.avatar as? AvatarImageView
        
        if let photo_uri = friend?.photo_uri {
            avatar?.downloaded(from: photo_uri)
        }
        
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

extension FriendInfoController: FriendImageSelector {
    func getFriendImagesCount() -> Int {
//        return friend?.avatars.count ?? 0
        return 1
    }
    
    func getFriendCurrentImageIndex() -> Int {
        return imageIndex
    }
    
    func updateFriendCurrentImageIndex(id: Int) {
        imageIndex = id
    }
    
    func getFriendImage(id: Int) -> UIImage?{
//        return friend?.avatars[id]
        return #imageLiteral(resourceName: "news3")
    }
}

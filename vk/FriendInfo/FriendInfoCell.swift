import UIKit

class FriendInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    weak var delegate: FriendImageSelector?
    var friendImagesCount: Int = 0
    var friendCurrentImageIndex: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        rightSwipeRecognizer.direction = .right
        leftSwipeRecognizer.direction = .left
        rightSwipeRecognizer.delegate = self
        leftSwipeRecognizer.delegate = self
        addGestureRecognizer(rightSwipeRecognizer)
        addGestureRecognizer(leftSwipeRecognizer)
    }
}

extension FriendInfoCell: UIGestureRecognizerDelegate {
    @objc func swiped(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            guard let currentIndex = delegate?.getFriendCurrentImageIndex(), let imagesCount = delegate?.getFriendImagesCount() else {
                return
            }
            
            switch swipeGesture.direction {
            case .left:
                print("swiped left")
                if currentIndex < imagesCount - 1 {
                    let newIndex = currentIndex + 1
                    let image = delegate?.getFriendImage(id: newIndex)
                    avatar.image = image
                    delegate?.updateFriendCurrentImageIndex(id: newIndex)
                    animateImage()
                }
            case .right:
                print("swiped right")
                if currentIndex > 0 {
                    let newIndex = currentIndex - 1
                    let image = delegate?.getFriendImage(id: newIndex)
                    avatar.image = image
                    delegate?.updateFriendCurrentImageIndex(id: newIndex)
                    animateImage()
                }
            default:
                break
            }
        }
    }
    
    func animateImage() {
        UIView.transition(with: self, duration: 1, options: .transitionCrossDissolve, animations: {
            self.contentView.transform = CGAffineTransform(scaleX: 0.6, y: 0.8)
        })

        let right = CGAffineTransform(translationX: 300, y: 0)
        let left = CGAffineTransform(translationX: -300, y: 0)
        UIView.animate(withDuration: 1) {
            self.contentView.transform = right
        }
        self.contentView.transform = left
    }
}

protocol FriendImageSelector: class {
    func getFriendImagesCount() -> Int
    func getFriendCurrentImageIndex() -> Int
    func updateFriendCurrentImageIndex(id: Int)
    func getFriendImage(id: Int) -> UIImage?
}

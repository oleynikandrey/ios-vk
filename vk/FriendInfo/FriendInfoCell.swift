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
    enum Direction {
        case right
        case left
    }
    
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
                    delegate?.updateFriendCurrentImageIndex(id: newIndex)
                    animateImage(direction: .left, image: image)
                }
            case .right:
                print("swiped right")
                if currentIndex > 0 {
                    let newIndex = currentIndex - 1
                    let image = delegate?.getFriendImage(id: newIndex)
                    delegate?.updateFriendCurrentImageIndex(id: newIndex)
                    animateImage(direction: .right, image: image)
                }
            default:
                break
            }
        }
    }
    
    func animateImage(direction: Direction, image: UIImage?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.avatar.image = image
        }
        
        UIView.animateKeyframes(withDuration: 1.52, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                self.avatar.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.001, animations: {
                self.avatar.transform = .identity
                if direction == .right {
                    self.avatar.center.x -= 300
                } else {
                    self.avatar.center.x += 300
                }
            })
       
            UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.5) {
                if direction == .right {
                    self.avatar.center.x += 300
                } else {
                    self.avatar.center.x -= 300
                }
            }
        })
    }
}

protocol FriendImageSelector: class {
    func getFriendImagesCount() -> Int
    func getFriendCurrentImageIndex() -> Int
    func updateFriendCurrentImageIndex(id: Int)
    func getFriendImage(id: Int) -> UIImage?
}

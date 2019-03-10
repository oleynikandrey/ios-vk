import UIKit

@IBDesignable class LikeControl: UIStackView {
    
    private var elements = [UIView]()
    
    @IBInspectable var elementSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupControls()
        }
    }
    
    var likes = 0 {
        didSet {
            updateCounter()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControls()
        updateCounter()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupControls()
        updateCounter()
    }
    
    private func setupControls() {
        for element in elements {
            removeArrangedSubview(element)
            element.removeFromSuperview()
        }
        elements.removeAll()
        
        let button = UIButton()
        
        // Set the button images
        button.setImage(UIImage(named:"emptyHeart"), for: .normal)
        button.setImage(UIImage(named: "filledHeart"), for: .selected)
        
        // Add constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: elementSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: elementSize.width).isActive = true
        
        button.addTarget(self, action: #selector(LikeControl.likeButtonTapped(button:)), for: .touchUpInside)
        
        addArrangedSubview(button)
        elements.append(button)
        
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: elementSize.height).isActive = true
        label.widthAnchor.constraint(equalToConstant: elementSize.width).isActive = true
        
        addArrangedSubview(label)
        elements.append(label)
    }
    
    private func updateCounter() {
        let label = elements[1] as! UILabel
        label.text = "\(likes)"
    }
    
    // MARK: Button Action
    @objc func likeButtonTapped(button: UIButton) {
        if button.isSelected {
            likes -= 1
        } else {
            likes += 1
        }
        button.isSelected = !button.isSelected
    }
}

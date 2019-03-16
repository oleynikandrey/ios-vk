import Foundation
import UIKit

class AvatarImageView: UIImageView {
    
    override var image: UIImage? {
        didSet {
            super.image = image
            setupView()
        }
    }
    
    @IBInspectable var showShadow: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 6 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shadowColor: CGColor = UIColor.black.cgColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private func addShadow() {
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.6
        layer.shadowRadius = shadowRadius
        layer.shadowColor = shadowColor
        layer.masksToBounds = false
    }
    
    func moveContentToAnotherLayerAndMakeItRound() {
        if let contents = layer.contents {
            image = nil
            let contentLayer = CALayer()
            contentLayer.contents = contents
            contentLayer.frame = layer.bounds
            contentLayer.cornerRadius = min(frame.width / 2, frame.height / 2)
            contentLayer.masksToBounds = true
            layer.addSublayer(contentLayer)
        }
    }
    
    func setupView() {
        moveContentToAnotherLayerAndMakeItRound()
        if showShadow {
            addShadow()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
       }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
       }
    
    override func layoutSublayers(of layer: CALayer) {
        setupView()
       }
}

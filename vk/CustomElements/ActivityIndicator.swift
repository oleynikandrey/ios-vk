import UIKit

@IBDesignable class ActivityIndicator: UIStackView {

    private var elements = [UIImageView] ()
    
    @IBInspectable var elementSize: CGSize = CGSize(width: 20.0, height: 20.0) {
        didSet {
            setupControl()
        }
    }
    
    func setupControl() {
        for element in elements {
            removeArrangedSubview(element)
            element.removeFromSuperview()
        }
        elements.removeAll()
        
        for _ in 0...2 {
            guard let image = UIImage(named: "activityIndicator") else {
                return
            }
            let view = UIImageView.init(image: image)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalToConstant: elementSize.width).isActive = true
            view.heightAnchor.constraint(equalToConstant: elementSize.height).isActive = true
            
            addArrangedSubview(view)
            elements.append(view)
        }
    }
    
    private func startAnimation() {
        let duration: Double = 0.6
        UIView.animate(withDuration: duration, animations: {
            self.elements[2].alpha = 1
            self.elements[0].alpha = 0.2
        }, completion: { _ in
            UIView.animate(withDuration: duration, animations: {
                self.elements[0].alpha = 1
                self.elements[1].alpha = 0.2
            }, completion: { _ in
                UIView.animate(withDuration: duration, animations: {
                    self.elements[1].alpha = 1
                    self.elements[2].alpha = 0.2
                }, completion: { _ in
                    self.startAnimation()
                })
            })
        })
    }
    
    private func setupView() {
        spacing = 2.0
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupControl()
        startAnimation()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupControl()
        startAnimation()
    }

}

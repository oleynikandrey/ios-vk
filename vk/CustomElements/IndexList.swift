import UIKit

@IBDesignable class IndexList: UIControl {
    weak var delegate: TableSectionSelecter?
    
    var letters: [String] = []
    
    private var buttons: [UIButton] = []
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    func setupView() {
        for char in letters.sorted() {
            let button = UIButton(type: .system)
            button.setTitle(String.init(char), for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.setTitleColor(.red, for: .selected)
            button.addTarget(self, action: #selector(selectLetter(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        stackView = UIStackView(arrangedSubviews: self.buttons)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        addSubview(stackView)
    }
    
    @objc func selectLetter(_ sender: UIButton) {
        delegate?.selectedSection(sectionLetter: sender.titleLabel!.text!)
    }
}

protocol TableSectionSelecter: class {
    func selectedSection(sectionLetter: String)
}

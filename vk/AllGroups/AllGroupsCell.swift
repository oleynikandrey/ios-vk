import UIKit

class AllGroupsCell: UITableViewCell {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var addGroupTapped : ((String, UIImage) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func addGroup(_ sender: Any) {
        guard let text = groupName.text, let image = groupImage.image else {
            return
        }
        addGroupTapped?(text, image)
        disableAddButton()
    }
    
    func disableAddButton() {
        addButton.isEnabled = false
    }
}

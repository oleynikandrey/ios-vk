//
//  NewsViewCell.swift
//  vk
//
//  Created by Andrey Oleynik on 17/03/2019.
//  Copyright © 2019 Andrey Oleynik. All rights reserved.
//

import UIKit

class NewsViewCell: UITableViewCell {
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsViews: UILabel!
    @IBOutlet weak var newsLikeControl: LikeControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImage.image = nil
    }

    
}

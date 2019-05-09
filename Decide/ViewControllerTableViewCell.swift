//
//  ViewControllerTableViewCell.swift
//  Decide
//
//  Created by Ayesha Nabiha on 4/11/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

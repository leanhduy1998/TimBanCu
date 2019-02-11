//
//  MajorTableViewCell.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/2/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class MajorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var majorLabel: UILabel!
    
    var major:Major! = nil{
        didSet{
            majorLabel.text = major.name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

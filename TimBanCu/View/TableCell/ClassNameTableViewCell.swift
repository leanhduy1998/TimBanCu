//
//  ClassNameTableViewCell.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class ClassNameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var classLabel: UILabel!
    
    @IBOutlet weak var imageview: UIImageView!
    
    
    var classNameViewModel:ClassNameViewModel! = nil {
        didSet{
            classLabel.text = classNameViewModel.className
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

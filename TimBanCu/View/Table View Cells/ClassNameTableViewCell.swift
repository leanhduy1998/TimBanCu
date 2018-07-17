//
//  ClassDetailTableViewCell.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class ClassNameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var classLabel: UILabel!
    
    @IBOutlet weak var imageview: UIImageView!
    
    
    var classDetailViewModel:ClassNameViewModel! = nil {
        didSet{
            classLabel.text = classDetailViewModel.className
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

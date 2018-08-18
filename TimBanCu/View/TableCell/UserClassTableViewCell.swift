//
//  UserClassTableViewCell.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class UserClassTableViewCell: UITableViewCell {
    
    @IBOutlet weak var className: UILabel!
    
    @IBOutlet weak var schoolName: UILabel!
    
    @IBOutlet weak var classYear: UILabel!
    
    var userClassesViewModel:UserClassesViewModel! = nil {
        didSet{
            className.text = userClassesViewModel.className
            schoolName.text  = userClassesViewModel.schoolName
            classYear.text = userClassesViewModel.classYear
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

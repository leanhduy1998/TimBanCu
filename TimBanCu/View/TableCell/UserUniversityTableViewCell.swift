//
//  UserUniversityTableViewCell.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/6/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class UserUniversityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var majorLabel: UILabel!
    
    @IBOutlet weak var schoolNameLabel: UILabel!
    
    @IBOutlet weak var classYearLabel: UILabel!
    
    var viewModel: UserUniversityViewModel! = nil {
        didSet{
            majorLabel.text = viewModel.majorName
            schoolNameLabel.text = viewModel.schoolName
            classYearLabel.text = viewModel.classYear
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

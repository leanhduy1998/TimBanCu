//
//  SchoolTableViewCell.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/7/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class SchoolTableViewCell: UITableViewCell {
    
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var schoolAddress: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    
    
    var schoolViewModel:SchoolViewModel! = nil {
        didSet{
            schoolName.text = schoolViewModel.name
            
            if(schoolViewModel.address == nil){
                schoolAddress.text = "Không rõ địa chỉ"
            }
            else{
                schoolAddress.text = schoolViewModel.address
            }
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

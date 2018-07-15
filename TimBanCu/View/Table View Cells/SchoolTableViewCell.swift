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
    
    enum scanType :String{
        case elementary
        case secondary
        case highschool
        case university
        case all
    }
    
    var schoolViewModel:SchoolViewModel! = nil {
        didSet{
            schoolName.text = schoolViewModel.name
            
            if(schoolViewModel.address == "?"){
                schoolAddress.text = "Không rõ địa chỉ"
            }
            else{
                schoolAddress.text = schoolViewModel.address
            }
            
            /*
            if(schoolViewModel.image == nil){
                if(schoolViewModel.type == scanType.elementary.rawValue){
                    imageview.image = #imageLiteral(resourceName: "elementary")
                }
                else if(schoolViewModel.type == scanType.secondary.rawValue){
                    imageview.image = #imageLiteral(resourceName: "middle")
                }
                else if(schoolViewModel.type == scanType.highschool.rawValue){
                    imageview.image = #imageLiteral(resourceName: "middle")
                }
                else if(schoolViewModel.type == scanType.university.rawValue){
                    imageview.image = #imageLiteral(resourceName: "university")
                }
            }
            else{
                imageview.image = schoolViewModel.image
            }*/
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

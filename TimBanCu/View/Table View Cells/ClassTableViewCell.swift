//
//  ElementaryTableViewCell.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/9/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class ClassTableViewCell: UITableViewCell {
    
    @IBOutlet weak var classLabel: UILabel!
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 2.5
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
        view.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        constraintContainer()
    }
    
    func constraintContainer() {
        self.addSubview(container)
        container.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        container.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 60).isActive = true
        container.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -60).isActive = true
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  ImageDetailViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/28/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class StudentImageDetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageview: UIImageView!
    var image:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageview.image = image
    }
}

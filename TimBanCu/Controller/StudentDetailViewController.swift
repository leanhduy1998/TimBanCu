//
//  StudentDetailViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/26/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import ImageSlideshow

class StudentDetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthYearLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var selectedStudent:Student!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = selectedStudent.fullName
        birthYearLabel.text = selectedStudent.birthYear
        
        if(selectedStudent.phoneNumber == nil){
            phoneLabel.text = "Số Điện Thoại Này Không Được Công Khai."
        }
        else{
            phoneLabel.text = selectedStudent.phoneNumber
        }
        
        if(selectedStudent.email == nil){
            emailLabel.text = "Địa Chỉ Email Này Không Được Công Khai."
        }
        else{
            emailLabel.text = selectedStudent.email
        }
        
        
        
    }

   
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}

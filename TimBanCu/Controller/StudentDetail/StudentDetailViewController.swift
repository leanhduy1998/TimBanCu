//
//  StudentDetailViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/26/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import ImageSlideshow
import FirebaseStorage
import Hero

class StudentDetailViewController: UIViewController {
    
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthYearLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var student:Student!

    var selectedImage:Image!
    var userImages = [Image]()
    
    
    private var uiController: StudentDetailUIController!
    private var controller:StudentDetailController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImages = CurrentUser.getStudent().images
        
        uiController = StudentDetailUIController(viewcontroller: self)
        controller = StudentDetailController(viewcontroller: self)
       
        controller.fetchStudentImages { (uiState) in
            self.uiController.state = uiState
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UserImageViewController{
            destination.image = selectedImage
            destination.userImages = userImages
        }
    }
    

}

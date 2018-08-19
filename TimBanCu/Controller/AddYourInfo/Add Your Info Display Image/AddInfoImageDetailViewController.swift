//
//  ImageDetailViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/21/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class AddInfoImageDetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    
    var indexForDeletion:Int!
    
    var userImages = [UIImage]()
    var yearOfUserImage = [UIImage:Int]()
    
    var editImageYearAlert:UIAlertController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlert()
    }
    override func viewDidLayoutSubviews() {
        setupImageView()
        setupYearLabelText()
    }
    
    func setupImageView(){
        let image = userImages[indexForDeletion]
        imageview.image = image
    }
    
    func setupYearLabelText(){
        let image = userImages[indexForDeletion]
        let year = yearOfUserImage[image]
        
        if(year == -1){
            yearLabel.text = "Không Rõ Năm"
        }
        else{
            yearLabel.text = "Năm \(year!)"
        }
    }
    
    
    @IBAction func changeYearButtonPressed(_ sender: Any) {
        let year = yearOfUserImage[userImages[indexForDeletion]]
        
        if(year == -1){
            editImageYearAlert.message = "Không Rõ Năm"
        }
        else{
            editImageYearAlert.message = "Năm Hiện Tại: \(year!)"
        }
        
        present(editImageYearAlert, animated: true, completion: nil)
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        yearOfUserImage[userImages[indexForDeletion]] = nil
        userImages.remove(at: indexForDeletion)
        performSegue(withIdentifier: "unwindToAddYourInfoControllerWithSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddYourInfoViewController{
            destination.userImages = userImages
            destination.yearOfUserImage = yearOfUserImage
        }
    }
    

}

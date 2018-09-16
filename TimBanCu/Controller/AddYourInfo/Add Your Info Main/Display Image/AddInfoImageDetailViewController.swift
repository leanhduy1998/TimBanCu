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
    
    var userImages = [Image]()
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
        imageview.image = image.image
    }
    
    func setupYearLabelText(){
        let image = userImages[indexForDeletion]
        
        if(image.year == nil){
            yearLabel.text = "Không Rõ Năm"
        }
        else{
            yearLabel.text = "Năm \(image.year!)"
        }
    }
    
    
    @IBAction func changeYearButtonPressed(_ sender: Any) {
        let image = userImages[indexForDeletion]
        if(image.year == nil){
            editImageYearAlert.message = "Không Rõ Năm"
        }
        else{
            editImageYearAlert.message = "Năm Hiện Tại: \(image.year!)"
        }
        
        present(editImageYearAlert, animated: true, completion: nil)
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        userImages.remove(at: indexForDeletion)
        performSegue(withIdentifier: "unwindToAddYourInfoControllerWithSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddYourInfoViewController{
            destination.userImages = userImages
        }
    }
}

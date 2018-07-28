//
//  ImageDetailViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/21/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class ImageDetailInAddInfoViewController: UIViewController {
    
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    
    var indexForDeletion:Int!
    
    var userImages = [UIImage]()
    var yearOfUserImage = [UIImage:Int]()
    
    var editImageYearAlert = UIAlertController(title: "Sửa Năm Hình Này Được Chụp!", message: "", preferredStyle: .alert)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editImageYearAlert.addTextField { (textField) in
            textField.placeholder = "Năm Hình Được Chụp"
            textField.keyboardType = .numberPad
        }
        
        editImageYearAlert.addAction(UIAlertAction(title: "Sửa Năm", style: .default, handler: { [weak editImageYearAlert] (_) in
            let textField = editImageYearAlert?.textFields![0] // Force unwrapping because we know it exists.
            let year = Int((textField?.text)!)
            self.yearOfUserImage[self.userImages[self.indexForDeletion]] = year
            self.performSegue(withIdentifier: "unwindToAddYourInfoControllerWithSegue", sender: self)
        }))
    }
    override func viewDidLayoutSubviews() {
        let image = userImages[indexForDeletion]
        
        imageview.image = image
        
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

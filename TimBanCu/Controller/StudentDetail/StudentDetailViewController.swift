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

    var selectedImage:UIImage!
    
    var userImages = [UIImage]()
    var yearOfUserImage = [UIImage:Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = student.fullName
        birthYearLabel.text = student.birthYear
        
        nameLabel.hero.isEnabled = true
        imageSlideshow.hero.isEnabled = true
        nameLabel.hero.id = "\(student.fullName)"
        imageSlideshow.hero.id = "\(student.fullName)image"
        
        if(student.phoneNumber == nil){
            phoneLabel.text = "Số Điện Thoại Này Không Được Công Khai."
        }
        else{
            phoneLabel.text = student.phoneNumber
        }
        
        if(student.email == nil){
            emailLabel.text = "Địa Chỉ Email Này Không Được Công Khai."
        }
        else{
            emailLabel.text = student.email
        }
        
        setupimageSlideshow()
        
        
        for(photoName,year) in student.imageUrls{
            Storage.storage().reference().child("users").child(student.uid).child(photoName).getData(maxSize: INT64_MAX) { (imageData, error) in
                
                
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData!)
                    self.userImages.append(image!)
                    self.yearOfUserImage[image!] = year
                    
                    self.reloadimageSlideshow()
                }
            }
        }
    }
    
    func reloadYearLabel(page:Int){
        if(yearOfUserImage[userImages[page]] == -1){
            yearLabel.text = "Năm ?"
        }
        else{
            yearLabel.text = "\(yearOfUserImage[userImages[page]]!)"
        }
        view.layoutIfNeeded()
    }
    
    func setupimageSlideshow(){
        let pageIndicator = UIPageControl()
        imageSlideshow.pageIndicator = pageIndicator
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        imageSlideshow.addGestureRecognizer(gestureRecognizer)
        
        
        imageSlideshow.currentPageChanged = { page in
            DispatchQueue.main.async {
                self.reloadYearLabel(page: page)
            }
        }
    }
    
    @objc func didTap() {
        selectedImage = userImages[imageSlideshow.currentPage]
        performSegue(withIdentifier: "StudentDetailToImageDetailSegue", sender: self)
    }
    
    func reloadimageSlideshow(){
        var imageSources = [ImageSource]()
        
        for image in userImages{
            imageSources.append(ImageSource(image: image))
        }
        
        imageSlideshow.setImageInputs(imageSources)
        
        self.imageSlideshow.setCurrentPage(0, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? StudentImageDetailViewController{
            destination.image = selectedImage
        }
    }
    

}

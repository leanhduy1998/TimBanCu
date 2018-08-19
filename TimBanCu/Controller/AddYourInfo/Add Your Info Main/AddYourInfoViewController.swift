//
//  AddYourInfoViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/17/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import DropDown
import FirebaseDatabase
import ImageSlideshow
import FirebaseStorage

class AddYourInfoViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var birthYearTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phonePrivacyDropDownBtn: UIButton!
    @IBOutlet weak var emailPrivacyDropDownBtn: UIButton!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    @IBOutlet weak var yearLabel: UILabel!
    @IBAction func unwindToAddYourInfoController(segue:UIStoryboardSegue) { }
    
    var phonePrivacyDropDown = DropDown()
    var emailPrivacyDropDown = DropDown()
    
    var userImages = [UIImage]()
    var yearOfUserImage = [UIImage:Int]()
    var selectedImage:UIImage!
    
    var addImageYearAlert:UIAlertController!
    var privacyAlert:UIAlertController!
    
    var privateUserProfileRef:DatabaseReference!
    var publicUserProfileRef:DatabaseReference!
    
    // from previous class
    var classDetail:ClassDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPrivacyDropDowns()
        setupAlerts()
        setupImageSlideShow()
        reloadImageSlideShow()
        observeKeyboardNotifications()
        
        setupUserImages()
        setupImageSlideShow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFirebaseReference()
    }
    
    private func setupFirebaseReference(){
        privateUserProfileRef = Database.database().reference().child("privateUserProfile")
        publicUserProfileRef = Database.database().reference().child("publicUserProfile")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateImageSlideShow(count: 0)
    }
    
    func setupUserImages(){
        if(userImages.count == 0){
            userImages.append(#imageLiteral(resourceName: "addImage"))
        }
        if(userImages.count>1){
            reloadYearLabel(page: imageSlideShow.currentPage)
        }
    }
    
    override func viewWillLayoutSubviews() {
        phonePrivacyDropDown.anchorView = phonePrivacyDropDownBtn
        emailPrivacyDropDown.anchorView = emailPrivacyDropDownBtn
    }
    
    
    @IBAction func addInfoBtnPressed(_ sender: Any) {
        removeThePlusIconPictureThatIsUsedToAddNewPicture()
        
        let imageAndName = getNameForImage()
        
        uploadPublicData(imageFileNames: imageAndName)
        uploadPrivateData()
        updateCurrentStudentInfo()
        uploadUserInfoToSelectedClass()
        uploadUserImages(imageFileNames: imageAndName, completionHandler: {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "AddYourInfoToClassDetailSegue", sender: self)
            }
        })
    }
    
    private func getNameForImage() -> [UIImage:String]{
        let time = Date().timeIntervalSince1970.binade
        
        var imageAndName = [UIImage:String]()
        
        for x in 0...(self.userImages.count-1){
            let str = "\(String(Int(time)+x))"
            imageAndName[userImages[x]] = str
        }
        
        return imageAndName
    }
    
    func reloadYearLabel(page:Int){
        if(yearOfUserImage[userImages[page]] == nil){
            yearLabel.text = "Năm ?"
        }
        else{
            yearLabel.text = "\(yearOfUserImage[userImages[page]]!)"
        }
        view.layoutIfNeeded()
    }
    
    private func removeThePlusIconPictureThatIsUsedToAddNewPicture(){
        userImages.removeLast()
    }
    
    
    
    @IBAction func showPrivacyAlertBtnPressed(_ sender: Any) {
        present(privacyAlert, animated: true, completion: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddInfoImageDetailViewController{
            destination.indexForDeletion = imageSlideShow.currentPage
            destination.userImages = userImages
            destination.yearOfUserImage = yearOfUserImage
        }
        if let destination = segue.destination as? AddImagesViewController{
            destination.currentImages = userImages
        }

    }
}



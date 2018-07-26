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

class AddYourInfoViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    var addImageYearAlert = UIAlertController(title: "Bạn Nên Thêm Năm Hình Này Được Chụp!", message: "Mọi người sẽ dễ nhận diện bạn hơn!", preferredStyle: .alert)
    
    var privacyAlert = UIAlertController(title: "Mức Công Khai Thông Tin", message: "Bạn có thể chọn chia sẻ thông tin của mình công khai hoặc chỉ mình bạn. Nếu không công khai, người dùng khác sẽ phải được sự đồng ý của bạn trước khi xem thông tin đó.", preferredStyle: .alert)
    
    let privateUserProfileRef = Database.database().reference().child("privateUserProfile")
    let publicUserProfileRef = Database.database().reference().child("publicUserProfile")
    
    var selectedSchool:School!
    var selectedClassNumber: String!
    var selectedClassName:ClassName!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPrivacyDropDowns()
        setupAlerts()
        setupImageSlideShow()
        reloadImageSlideShow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateImageSlideShow(count: 0)
        
        
        if(userImages.count>0){
           reloadYearLabel(page: imageSlideShow.currentPage)
        }
        reloadImageSlideShow()
    }
    
    @IBAction func phoneDropDownBtnPressed(_ sender: Any) {
        phonePrivacyDropDown.show()
    }
    
    @IBAction func emailDropDownBtnPressed(_ sender: Any) {
        emailPrivacyDropDown.show()
    }
    
    @IBAction func addInfoBtnPressed(_ sender: Any) {

        var filenames = [String]()
        let time = Date().timeIntervalSince1970.binade
        
        for x in 0...(self.userImages.count-1){
            let str = "\(Int(time)+x).jpg"
            filenames.append(str)
        }
        
        uploadPublicData(imageFileNames: filenames)
        uploadPrivateData()
        
        UserHelper.student = Student(fullname: self.fullNameTF.text!, birthYear: self.birthYearTF.text!, phoneNumber: self.phoneTF.text!, email: self.emailTF.text!, uid: UserHelper.uid)
        
        uploadUserImages(imageFileNames: filenames, completionHandler: {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "AddYourInfoToClassDetailSegue", sender: self)
            }
        })
        
        uploadUserInfoToSelectedClass()
    }
    
    func uploadUserInfoToSelectedClass(){
         Database.database().reference().child("students").child(selectedSchool.name).child(selectedClassNumber).child(selectedClassName.className).child(UserHelper.uid).setValue(UserHelper.student.fullName)
    }
    
    func uploadPublicData(imageFileNames:[String]){
        var publicDic = [String:Any]()
        
        if(phonePrivacyDropDownBtn.currentTitle == "Công Khai"){
            publicDic["phoneNumber"] = phoneTF.text
        }
        
        if(emailPrivacyDropDownBtn.currentTitle == "Công Khai"){
            publicDic["email"] = emailTF.text
        }
        
        publicDic["birthYear"] = birthYearTF.text
        publicDic["fullName"] = fullNameTF.text
        
        publicDic["images"] = imageFileNames
        
        publicUserProfileRef.child(UserHelper.uid).setValue(publicDic)
    }
    
    func uploadPrivateData(){
        var privateDic = [String:Any]()
        
        if(phonePrivacyDropDownBtn.currentTitle == "Chỉ Riêng Tôi"){
            privateDic["phoneNumber"] = phoneTF.text
        }
        
        if(emailPrivacyDropDownBtn.currentTitle == "Chỉ Riêng Tôi"){
            privateDic["email"] = emailTF.text
        }
        
        privateUserProfileRef.child(UserHelper.uid).setValue(privateDic)
    }
    
    func uploadUserImages(imageFileNames:[String], completionHandler: @escaping () -> Void){
        
        let storage = Storage.storage()
        
        var imageUploaded = 0
        
        var x = 0
        for name in imageFileNames{
            let imageRef = storage.reference().child("users").child("\(UserHelper.uid!)/\(name)")
            
            let data = userImages[x].jpeg(UIImage.JPEGQuality(rawValue: 0.5)!)
            
            let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print()
                    return
                }
                imageUploaded = imageUploaded + 1
                
                if(imageUploaded == imageFileNames.count){
                    completionHandler()
                }
            }
            x = x + 1
        }
    }
    
    
    @IBAction func addPictureBtnPressed(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func showPrivacyAlertBtnPressed(_ sender: Any) {
        present(privacyAlert, animated: true, completion: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ImageDetailViewController{
            destination.indexForDeletion = imageSlideShow.currentPage
            destination.userImages = userImages
            destination.yearOfUserImage = yearOfUserImage
        }
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}

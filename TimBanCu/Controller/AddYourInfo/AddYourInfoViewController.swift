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
    

    var classDetail:ClassDetail!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPrivacyDropDowns()
        setupAlerts()
        setupImageSlideShow()
        reloadImageSlideShow()
        
        let storage = Storage.storage()

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

        var filenames = [UIImage:String]()
        let time = Date().timeIntervalSince1970.binade
        
        for x in 0...(self.userImages.count-1){
            let str = "\(String(Int(time)+x))"
            filenames[userImages[x]] = str
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
         Database.database().reference().child("students").child(classDetail.schoolName).child(classDetail.classNumber).child(classDetail.className).child(UserHelper.uid).setValue(UserHelper.student.fullName)
    }
    
    func uploadPublicData(imageFileNames:[UIImage:String]){
        var publicDic = [String:Any]()
        
        if(phonePrivacyDropDownBtn.currentTitle == "Công Khai"){
            publicDic["phoneNumber"] = phoneTF.text
        }
        
        if(emailPrivacyDropDownBtn.currentTitle == "Công Khai"){
            publicDic["email"] = emailTF.text
        }
        
        publicDic["birthYear"] = birthYearTF.text
        publicDic["fullName"] = fullNameTF.text
        
        var dic = [String:Int]()
        
        for image in userImages{
            dic[imageFileNames[image]!] = yearOfUserImage[image]
        }
        
        publicDic["images"] = dic
        
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
    
    func uploadUserImages(imageFileNames:[UIImage:String], completionHandler: @escaping () -> Void){
        
        let storage = Storage.storage()
        
        var imageUploaded = 0
        
  
        
        for image in userImages{
            let name = imageFileNames[image]
            let imageRef = storage.reference().child("users").child("\(UserHelper.uid!)/\(name!)")
            
            let data = image.jpeg(UIImage.JPEGQuality(rawValue: 0.5)!)
            
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
        }
        
        
        
    }
    
    @IBAction func showPrivacyAlertBtnPressed(_ sender: Any) {
        present(privacyAlert, animated: true, completion: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ImageDetailInAddInfoViewController{
            destination.indexForDeletion = imageSlideShow.currentPage
            destination.userImages = userImages
            destination.yearOfUserImage = yearOfUserImage
        }

    }
}



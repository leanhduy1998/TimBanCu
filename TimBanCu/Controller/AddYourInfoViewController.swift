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

class AddYourInfoViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var birthYearTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phonePrivacyDropDownBtn: UIButton!
    @IBOutlet weak var emailPrivacyDropDownBtn: UIButton!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    
    var phonePrivacyDropDown = DropDown()
    var emailPrivacyDropDown = DropDown()
    
    var userImages = [UIImage]()
    var userImageWithYear = [UIImage:Int]()
    var selectedImage:UIImage!
    
    @IBOutlet weak var view1: UIView!
    
    var addImageYearAlert = UIAlertController(title: "Bạn Nên Thêm Năm Hình Này Được Chụp!", message: "Mọi người sẽ dễ nhận diện bạn hơn!", preferredStyle: .alert)
    
    
    var privacyAlert = UIAlertController(title: "Mức Công Khai Thông Tin", message: "Bạn có thể chọn chia sẻ thông tin của mình công khai hoặc chỉ mình bạn. Nếu không công khai, người dùng khác sẽ phải được sự đồng ý của bạn trước khi xem thông tin đó.", preferredStyle: .alert)
    
    let privateUserProfileRef = Database.database().reference().child("privateUserProfile")
    let publicUserProfileRef = Database.database().reference().child("publicUserProfile")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        phonePrivacyDropDown.dataSource = ["Công Khai", "Chỉ Riêng Tôi"]
        emailPrivacyDropDown.dataSource = ["Công Khai", "Chỉ Riêng Tôi"]
        
        privacyAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak privacyAlert] (_) in
            privacyAlert?.dismiss(animated: true, completion: nil)
        }))
        
        reloadImageSlideShow()
        
        let pageIndicator = UIPageControl()
        imageSlideShow.pageIndicator = pageIndicator
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        imageSlideShow.addGestureRecognizer(gestureRecognizer)
        
        addImageYearAlert.addTextField { (textField) in
            textField.placeholder = "Năm Hình Được Chụp"
            textField.keyboardType = .numberPad
        }
        
        addImageYearAlert.addAction(UIAlertAction(title: "Thêm", style: .default, handler: { [weak addImageYearAlert] (_) in
            let textField = addImageYearAlert?.textFields![0] // Force unwrapping because we know it exists.
            let year = Int((textField?.text)!)
            self.userImageWithYear[self.selectedImage] = year
            
            self.reloadYearLabel(page: self.imageSlideShow.currentPage)
        }))
        
        addImageYearAlert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { [weak addImageYearAlert] (_) in
            
        }))
 
        imageSlideShow.currentPageChanged = { page in
            
            DispatchQueue.main.async {
                self.reloadYearLabel(page: page)
            }
        }
    }
    
    func reloadYearLabel(page:Int){
        if(userImageWithYear[userImages[page]] == nil){
            yearLabel.text = "Năm ?"
        }
        else{
            yearLabel.text = "\(userImageWithYear[userImages[page]]!)"
        }
        view.layoutIfNeeded()
    }
    
    @objc func didTap() {
        if(userImageWithYear[userImages[imageSlideShow.currentPage]] == nil){
            selectedImage = userImages[imageSlideShow.currentPage]
            present(addImageYearAlert, animated: true, completion: nil)
        }

        imageSlideShow.presentFullScreenController(from: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateImageSlideShow(count: 0)
        
        
        if(userImages.count>0){
            if(self.userImageWithYear[self.userImages[imageSlideShow.currentPage]] == nil){
                self.yearLabel.text = "?"
            }
            else{
                self.yearLabel.text = "\(self.userImageWithYear[self.userImages[imageSlideShow.currentPage]]!)"
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    func animateImageSlideShow(count:Int){
        if(count <= (userImages.count-1)){
            let deadlineTime = DispatchTime.now() + .milliseconds(count*1000)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.imageSlideShow.setCurrentPage(count, animated: true)
                self.animateImageSlideShow(count: count + 1)
            }
        }
        else{
            self.imageSlideShow.setCurrentPage(0, animated: true)
        }
    }
    
    @IBAction func phoneDropDownBtnPressed(_ sender: Any) {
        phonePrivacyDropDown.show()
    }
    
    @IBAction func emailDropDownBtnPressed(_ sender: Any) {
        emailPrivacyDropDown.show()
    }
    
    @IBAction func addInfoBtnPressed(_ sender: Any) {
        var privateDic = [String:Any]()
        var publicDic = [String:Any]()
        
        if(phonePrivacyDropDown.selectedItem == "Công Khai"){
            publicDic["phoneNumber"] = phoneTF.text
        }
        else{
            privateDic["phoneNumber"] = phoneTF.text
        }
        
        if(emailPrivacyDropDown.selectedItem == "Công Khai"){
            publicDic["email"] = emailTF.text
        }
        else{
            privateDic["email"] = emailTF.text
        }
        
        publicDic["birthYear"] = birthYearTF.text
        publicDic["fullName"] = fullNameTF.text
        
        publicUserProfileRef.setValue(publicDic) { (err, ref) in
            if(err == nil){
                self.privateUserProfileRef.setValue(privateDic, withCompletionBlock: { (err2, ref2) in
                    
                    DispatchQueue.main.async {
                        UserHelper.student = Student(fullname: self.fullNameTF.text!, birthYear: self.birthYearTF.text!, phoneNumber: self.phoneTF.text!, email: self.emailTF.text!, uid: UserHelper.uid)
                        
                        self.performSegue(withIdentifier: "AddYourInfoToClassDetailSegue", sender: self)
                    }
                    
                })
            }
        }
    }
    
    
    @IBAction func addPictureBtnPressed(_ sender: Any) {
        var imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        userImages.append(image!)
        
        selectedImage = image
        
        
       
        dismiss(animated: true) {
            DispatchQueue.main.async {
                self.reloadImageSlideShow()
                self.present(self.addImageYearAlert, animated: true, completion: nil)
            }
            
        }
    }
    
    func reloadImageSlideShow(){
        if(userImages.count==0){
            imageSlideShow.setImageInputs([
                ImageSource(image: #imageLiteral(resourceName: "profile"))
            ])
        }
        else{
            var imageSources = [ImageSource]()
            
            for image in userImages{
                imageSources.append(ImageSource(image: image))
            }
            
            imageSlideShow.setImageInputs(imageSources)
            
            self.imageSlideShow.setCurrentPage(userImages.count-1, animated: true)
        }
    }
    
    
    @IBAction func showPrivacyAlertBtnPressed(_ sender: Any) {
        present(privacyAlert, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

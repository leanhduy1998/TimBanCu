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

class AddYourInfoViewController: UIViewController {
    
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var birthYearTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var phonePrivacyDropDownBtn: UIButton!
    
    
    @IBOutlet weak var emailPrivacyDropDownBtn: UIButton!
    
    var phonePrivacyDropDown = DropDown()
    var emailPrivacyDropDown = DropDown()
    
    

    
    @IBOutlet weak var view1: UIView!
    
    
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
                    
                })
            }
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

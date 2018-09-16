//
//  UpdateImageYearViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/13/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class UpdateImageYearViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    
    var selectedImage:Image!
    
    private var allowedLowerBoundYear:Int!
    private var allowedUpperBoundYear:Int!
    
    private var uiController:UpdateImageYearUIController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageview.image = selectedImage.image
        
        if(selectedImage.year != nil){
            yearTF.placeholder = selectedImage.year
        }
        
        yearTF.delegate = self
        yearTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        uiController = UpdateImageYearUIController(viewcontroller: self)
        
        setupYearBounds()
    }
    
    private func setupYearBounds(){
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        allowedLowerBoundYear = year - 80
        allowedUpperBoundYear = year
    }
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        if((Int(yearTF.text!)!) < allowedLowerBoundYear){
            uiController.showYearOutOfLowerBoundAlert()
        }
        else if((Int(yearTF.text!)!) > allowedUpperBoundYear){
            uiController.showYearIsInTheFutureAlert()
        }
        else{
            selectedImage.year = yearTF.text
            performSegue(withIdentifier: "UpdateImageYearToAddYourInfoControllerSegue", sender: self)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateBtn.isEnabled = !(textField.text?.isEmpty)!
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddYourInfoViewController{
            /*for image in destination.userImages{
                if(image.imageName == selectedImage.image){
                    image = selectedImage
                    break
                }
            }*/
        }
    }
    

}

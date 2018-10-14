//
//  ImageDetailViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/21/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import DropDown

class UserImageViewController: UIViewController {
    
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var optionBtn: UIButton!
    
    var image:Image!
    var userImages:[Image]!
    
    private var optionSelectedClosure:SelectionClosure!
    
    private var uiController:UserImageUIController!
    private var controller:UserImageController!
    
    private enum ImageAction:String{
        case DeleteImage = "Xoá Hình",ChangeImageYear = "Sửa Năm Hình"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupClosure()

        uiController = UserImageUIController(viewcontroller: self, selectionClosure: optionSelectedClosure)
        controller = UserImageController(viewcontroller: self)
    }
    
    
    func previousClassIsStudentDetailViewController()->Bool{
        let viewcontrollers = navigationController?.viewControllers
        let previousClass = viewcontrollers![(viewcontrollers?.count)!-2]
        
        if previousClass is StudentDetailViewController{
            return true
        }
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiController.reloadYearLabelText()
    }
    
    func setupClosure(){
        optionSelectedClosure = { (index,option) in
            switch(option){
            case ImageAction.DeleteImage.rawValue:
                self.deleteImage()
                break
            case ImageAction.ChangeImageYear.rawValue:
                self.changeYear()
                break
            default:
                break
            }
        }
    }
    
    @IBAction func optionBtnPressed(_ sender: Any) {
        uiController.showOptionDropdown()
    }
    
    private func changeYear(){
        performSegue(withIdentifier: "UserImageToUpdateYearSegue", sender: self)
    }
    
    private func deleteImage(){
        controller.removeImage(completionHandler: { uiState in
            self.uiController.uiState = uiState
            self.navigationController?.popViewController(animated: true)
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UpdateImageYearViewController{
            destination.selectedImage = image
        }
    }
}

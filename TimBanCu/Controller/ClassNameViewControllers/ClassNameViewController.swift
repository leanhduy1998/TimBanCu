//
//  ClassDetailViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/9/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Lottie

class ClassNameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    // From previous class
    var school:School!
    var classNumber: String!
    //
    
    var selectedClassDetail:ClassDetail!
    
    var uiController:ClassNameUIController!
    var controller:ClassNameController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiController = ClassNameUIController(viewcontroller: self, searchTF: searchTF, tableview: tableview, addNewClassNameHandler: { (addedClassName) in
            
            self.controller.addNewClass(className: addedClassName, completionHandler: { (uistate) in
                self.uiController.searchClassDetails = self.controller.classDetails
                self.uiController.state = uistate
            })
        })
        
        controller = ClassNameController(viewcontroller: self, school: school, classNumber: classNumber)
        
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        uiController.filterVisibleClassName(filter: textField.text!, allClassDetails: controller.classDetails)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        uiController.filterVisibleClassName(filter: "", allClassDetails: controller.classDetails)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controller.fetchData { (uistate) in
            self.uiController.searchClassDetails = self.controller.classDetails
            self.uiController.state = uistate
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassYearViewController{
            destination.classProtocol = selectedClassDetail
        }
    }
    

}

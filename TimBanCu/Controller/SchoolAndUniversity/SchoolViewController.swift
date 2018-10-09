//
//  SchoolViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/7/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Lottie
import Hero

class SchoolViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    var schoolType:SchoolType!
    var selectedSchool:School!
    
    private var uiController:SchoolUIController!
    private var controller:SchoolController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = SchoolController(schoolType: schoolType)
        
        uiController = SchoolUIController(viewcontroller: self, schoolType: schoolType, tableview: tableview, searchTF: searchTF, addNewSchoolClosure: { [weak self] newSchoolIfNotInList in
            
            self?.controller.addNewSchool(schoolName: newSchoolIfNotInList, completionHandler: { [weak self] (uiState) in
                self?.uiController.searchSchoolModels = (self?.controller.schoolModels)!
                self?.uiController.state = uiState
            })
            
        })
        
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        uiController.filterVisibleSchools(filter: textField.text!, allSchools: controller.schoolModels)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        uiController.filterVisibleSchools(filter: "", allSchools: controller.schoolModels)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        uiController.moveToNextControllerAnimation()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        uiController.state = .Loading

        controller.fetchData { [weak self] (uiState) in
            self?.uiController.searchSchoolModels = (self?.controller.schoolModels)!
            self?.uiController.state = uiState
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassViewController{
            
            switch(schoolType!){
            case .Elementary:
                destination.classes = ["Lớp 1", "Lớp 2", "Lớp 3", "Lớp 4", "Lớp 5"]
                break
            case .MiddleSchool:
                destination.classes = ["Lớp 6", "Lớp 7", "Lớp 8", "Lớp 9"]
                break
            case .HighSchool:
                destination.classes = ["Lớp 10", "Lớp 11", "Lớp 12"]
                break
            case .University:
                break
            }
            
            destination.school = selectedSchool
        }
        if let destination = segue.destination as? MajorViewController{
            destination.school = selectedSchool
        }
    }
}

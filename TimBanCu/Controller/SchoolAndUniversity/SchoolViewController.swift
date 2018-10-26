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
    
    var educationLevel:EducationLevel!
    var selectedInstitution:InstitutionFull!
    
    private var uiController:SchoolUIController!
    private var controller:SchoolController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = SchoolController(educationLevel: educationLevel)
        
        uiController = SchoolUIController(viewcontroller: self, schoolType: educationLevel, tableview: tableview, searchTF: searchTF, addNewSchoolClosure: { [weak self] newSchoolIfNotInList in
            
            self?.controller.addNewInstitution(name: newSchoolIfNotInList, completionHandler: { [weak self] (uiState) in
                self?.uiController.searchSchoolModels = (self?.controller.institutions)!
                self?.uiController.state = uiState
            })
            
        })
        
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        uiController.filterVisibleSchools(filter: textField.text!, allSchools: controller.institutions)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        uiController.filterVisibleSchools(filter: "", allSchools: controller.institutions)
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
            self?.uiController.searchSchoolModels = (self?.controller.institutions)!
            self?.uiController.state = uiState
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassNumberViewController{
            destination.educationLevel = educationLevel
            destination.school = selectedInstitution
        }
        if let destination = segue.destination as? MajorViewController{
            destination.institution = selectedInstitution
        }
    }
}

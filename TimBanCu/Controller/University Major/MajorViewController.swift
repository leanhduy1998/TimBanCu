//
//  UniversityMajorViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/2/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Lottie

class MajorViewController: UIViewController,UITextFieldDelegate {
    
    var school:School!
    var selectedMajor:MajorDetail!
    

    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var tableview: UITableView!
    
    var uiController: MajorUIController!
    var controller:MajorController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = MajorController(viewcontroller: self, school: school)
        
        uiController = MajorUIController(viewcontroller: self, tableview: tableview, searchTF: searchTF) { (newMajorIfNotInList) in
            self.controller.addNewMajor(inputedMajorName: newMajorIfNotInList, completionHandler: { (uiState) in
                self.uiController.searchMajors = self.controller.majors
                self.uiController.state = uiState
            })
        }
        
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controller.fetchData { (uiState) in
            self.uiController.searchMajors = self.controller.majors
            self.uiController.state = uiState
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        uiController.filterVisibleSchools(filter: textField.text!, allMajors: getAllDataFetched())
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        uiController.filterVisibleSchools(filter: "", allMajors: getAllDataFetched())
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func getAllDataFetched()->[MajorDetail]{
        return controller.majors
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        uiController.moveToNextControllerAnimation()
    }

    @objc func addNewMajorBtnPressed(_ sender: UIButton?) {
        uiController.showAddNewMajorAlert { (inputedMajorName) in
            if(!(inputedMajorName.isEmpty)){
                let major = MajorDetail(uid: CurrentUserHelper.getUid(), schoolName: self.school.name, majorName: inputedMajorName)
                
                self.selectedMajor = major
                
                self.performSegue(withIdentifier: "MajorToClassYearSegue", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassYearViewController{
            destination.classProtocol = selectedMajor
        }
    }
    
}


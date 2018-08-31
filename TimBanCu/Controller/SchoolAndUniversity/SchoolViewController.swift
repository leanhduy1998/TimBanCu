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

class SchoolViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    var schoolType:SchoolType!
    var selectedSchool:School!
    
    private var uiController:SchoolUIController!
    private var controller:SchoolController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiController = SchoolUIController(viewcontroller: self, schoolType: schoolType, tableview: tableview, searchTF: searchTF)
        controller = SchoolController(schoolType: schoolType)
    }
    
    func getAllDataFetched()->[School]{
        return controller.schoolModels
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        uiController.moveToNextControllerAnimation()
    }
    
    @objc func addNewSchoolBtnPressed(_ sender: UIButton?) {
        uiController.showAddNewSchoolAlert { (inputedSchoolName) in
            if(!(inputedSchoolName.isEmpty)){
                self.controller.addNewSchool(schoolName: inputedSchoolName, completionHandler: { (uiState) in
                    self.uiController.state = uiState
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        uiController.state = .Loading

        controller.fetchData { (uiState) in
            self.uiController.searchSchoolModels = self.controller.schoolModels
            self.uiController.state = uiState
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassViewController{
            
            switch(schoolType){
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
            default:
                break
            }
            
            destination.school = selectedSchool
        }
        if let destination = segue.destination as? MajorViewController{
            destination.school = selectedSchool
        }
    }
}

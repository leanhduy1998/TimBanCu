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

    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableview: UITableView!
    
    var institution:InstitutionFull!
    var selectedMajor:Major!
    
    private var uiController: MajorUIController!
    private var controller:MajorController!
    
    private var addNewClassView:AskForInputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNewClassView = AskForInputView(frame: view.frame, type:.Major, onAccept: { [weak self] (majorName) in
            
            guard let strongself = self else{
                return
            }
            
            for major in strongself.controller.majors{
                if major.name == majorName{
                    strongself.uiController.alerts.showAlert(title: "Khoa đã có trong danh sách của chúng tôi", message: "Bạn vui lòng thêm tên khác!")
                }
            }
            
            strongself.controller.addNewMajor(majorName: majorName, completionHandler: { err in
                
                if err == nil{
                    strongself.uiController.searchMajors = (strongself.controller.majors)
                    strongself.uiController.alerts.showAddNewMajorCompletedAlert()
                    strongself.uiController.filterVisibleSchools(filter: strongself.searchTF.text!, allMajors: strongself.controller.majors)
                }
                else{
                    if(err == "Permission denied") {
                        strongself.uiController.alerts.showMajorAlreadyExistAlert()
                    }
                    else{
                        strongself.uiController.alerts.showAlert(title: "Không Thể Thêm Khoa", message: err!)
                    }
                }
            })
        })
        
        view.addSubview(addNewClassView)
        
        controller = MajorController(viewcontroller: self, school: institution)
        
        uiController = MajorUIController(viewcontroller: self, tableview: tableview, searchTF: searchTF)
        
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controller.fetchData { [weak self] (uiState) in
            self?.uiController.searchMajors = (self?.controller.majors)!
            self?.uiController.state = uiState
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        uiController.filterVisibleSchools(filter: textField.text!, allMajors: controller!.majors)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        uiController.filterVisibleSchools(filter: "", allMajors: controller!.majors)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        uiController.moveToNextControllerAnimation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassYearViewController{
            destination.classProtocol = selectedMajor
        }
    }
    
}


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

class ClassNameViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    // From previous class
    var institution:InstitutionFull!
    var classNumber: String!
    
    var selectedClass:Class!
    
    fileprivate var uiController:ClassNameUIController!
    fileprivate var controller:ClassNameController!
    
    var state:ClassNameState = .NotAddingClass
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiController = ClassNameUIController(viewcontroller: self, searchTF: searchTF, tableview: tableview, addNewClassNameHandler: { [weak self] (addedClassName) in
            
            if(Class.nameExist(name: addedClassName, classes: self!.controller.classes)){
                self!.uiController.showClassAlreadyExistAlert()
            }
            else{
                self!.controller.addNewClass(className: addedClassName, completionHandler: { [weak self] (uistate) in
                    self?.uiController.searchClasses = self!.controller.classes
                    self?.uiController.state = uistate
                    self?.state = .AddingClass
                })
            }
        })
        
        controller = ClassNameController(viewcontroller: self)
        
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let backBTN = UIBarButtonItem(image: UIImage(named: "back"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(backBtnPressed(_:)))
        navigationItem.leftBarButtonItem = backBTN
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @IBAction func addNewClassBtnPressed(_ sender: Any) {
        self.uiController.showAddNewClassNameAlert()
        
    }
    
    @objc func backBtnPressed(_ sender: UIBarButtonItem){
        switch(state){
        case .AddingClass:
            uiController.showCancelAddingClassAlert()
        case .NotAddingClass:
            navigationController!.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controller.fetchData { (uistate) in
            self.uiController.searchClasses = self.controller.classes
            self.uiController.state = uistate
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassYearViewController{
            destination.classProtocol = selectedClass
        }
    }
}

//MARK: UITextFieldDelegate
extension ClassNameViewController:UITextFieldDelegate{
    @objc func textFieldDidChange(_ textField: UITextField) {
        uiController.filterVisibleClassName(filter: textField.text!, allClasses: controller.classes)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        uiController.searchTFDidBeginEditing(allClasses: controller!.classes)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        uiController.searchTFDidEndEditing(allClasses: controller.classes)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        uiController.filterVisibleClassName(filter: "", allClasses: controller.classes)
        return true
    }
}

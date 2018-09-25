//
//  ClassDetailViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/16/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Lottie

class ClassDetailViewController: UIViewController {
    
    @IBOutlet weak var addYourselfBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func unwindToClassDetailViewController(segue:UIStoryboardSegue) { }
    

    // segue from previous class
    var classProtocol:ClassProtocol!
    
    var selectedStudent:Student!
    
    private var uiController:ClassDetailUIController!
    private var controller:ClassDetailController!
    
    private var noResultViewAddBtnClosure:()->() = {}
    
    override func viewDidLoad() {
        setupClosure()
        uiController = ClassDetailUIController(viewcontroller: self, noResultViewAddBtnClosure: noResultViewAddBtnClosure)
        controller = ClassDetailController(classProtocol: classProtocol)
    }
    
    func setupClosure(){
        noResultViewAddBtnClosure =  {
            self.addYourselfBtn.sendActions(for: .touchUpInside)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        controller.fetchStudents { (uiState) in
            DispatchQueue.main.async {
                self.uiController.searchStudents = self.controller.students
                self.uiController.state = uiState
                
                self.controller.fetchStudentsImages(completionHandler: { (uiState2) in
                    self.uiController.state = uiState2
                })
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    func youAreInClass() -> Bool{
        for student in controller.students{
            if(student.uid == CurrentUser.getUid()){
                return true
            }
        }
        return false
    }
    
    func getAllStudents()->[Student]{
        return controller.students
    }
    

    @IBAction func addYourselfBtnPressed(_ sender: Any) {
        if(!CurrentUser.hasEnoughDataInFireBase()){
            performSegue(withIdentifier: "ClassDetailToAddYourInfoSegue", sender: self)
        }
        else{
            controller.enrollUserToClass { (uiState) in
                if case .Success() = uiState {
                    CurrentUser.addEnrollment(classD: self.classProtocol)
                }
                self.uiController.searchStudents = self.controller.students
                self.uiController.state = uiState
            }
        }
    }
    
    @IBAction func chatBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "ClassDetailToChatSegue", sender: self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddYourInfoViewController{
            destination.classDetail = classProtocol as? ClassDetail
        }
        if let destination = segue.destination as? StudentDetailViewController{
            destination.student = selectedStudent
        }
        
        if let destination = segue.destination as? ChatViewController{
            destination.classDetail = classProtocol as! ClassDetail
        }
        
    }

}

//MARK: UITextFieldDelegate
extension ClassDetailViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        uiController.searchTFDidChange()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        uiController.searchTFDidEndEditing()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

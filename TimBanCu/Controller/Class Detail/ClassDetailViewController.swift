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
    
    override func viewDidLoad() {
        uiController = ClassDetailUIController(viewcontroller: self, searchTF: searchTF, tableview: tableview, activityIndicator: activityIndicator, addYourselfBtn: addYourselfBtn, chatBtn: chatBtn)
        
        controller = ClassDetailController(classProtocol: classProtocol)
        
        createCopyOfClassProtocol()
    }
    
    // if the user goes back and forth between the screen, the same protocol will be used, thus same protocol for multiple class. Could have used struct, but in ClassYear we needed to change the year
    func createCopyOfClassProtocol(){
        if let classDetail = classProtocol as? ClassDetail{
            let copy = ClassDetail(classNumber: classDetail.classNumber, uid: classDetail.uid, schoolName: classDetail.schoolName, className: classDetail.className, classYear: classDetail.year)
            classProtocol = copy
        }
        if let majorDetail = classProtocol as? MajorDetail{
            let copy = MajorDetail(uid: majorDetail.uid, schoolName: majorDetail.schoolName, majorName: majorDetail.majorName, majorYear: majorDetail.year)
            classProtocol = copy
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        controller.fetchData { (uiState) in
            DispatchQueue.main.async {
                self.uiController.searchStudents = self.controller.students
                self.uiController.state = uiState
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    func youAreInClass() -> Bool{
        for student in controller.students{
            if(student.uid == CurrentUserHelper.getUid()){
                return true
            }
        }
        return false
    }
    

    @IBAction func addYourselfBtnPressed(_ sender: Any) {
        if(!CurrentUserHelper.hasEnoughDataInFireBase()){
            performSegue(withIdentifier: "ClassDetailToAddYourInfoSegue", sender: self)
        }
        else{
            controller.enrollUserToClass { (uiState) in
                if case .Success() = uiState {
                    CurrentUserHelper.addEnrollment(classD: self.classProtocol)
                }
                self.uiController.state = uiState
            }
        }
    }
    
    
    
    @IBAction func chatBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "ClassDetailToChatSegue", sender: self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddYourInfoViewController{
            destination.classDetail = classProtocol as! ClassDetail
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
        uiController.textFieldDidBeginEditing!()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        uiController.textFieldDidBeginEditing!()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

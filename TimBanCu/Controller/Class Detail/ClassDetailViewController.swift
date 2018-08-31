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

class ClassDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var addYourselfBtn: UIButton!
    
    @IBOutlet weak var chatBtn: UIButton!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func unwindToClassDetailViewController(segue:UIStoryboardSegue) { }
    

    // segue from previous class
    var classProtocol:ClassProtocol!
    //
    
    // backend
    var students = [Student]()
    var searchStudents = [Student]()
    var selectedStudent:Student!
    
    //no result
    var noResultLabel = NoResultLabel(type: NoResultType.Student)
    
    //ui
    let customSelectionColorView = CustomSelectionColorView()
    var finishedLoadingInitialTableCells = false
    let animatedEmoticon = LOTAnimationView(name: "empty_list")
    
    var searchTFUnderline = UnderlineView()
    var searchUnderlineHeightAnchor: NSLayoutConstraint?
    
    // firebase
    var classEnrollRef:DatabaseReference!
    
    override func viewDidLoad() {
        customizeSearchTF()
        setUpAnimatedEmoticon()
        setupNoResultLabel()
        
        tableview.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableview.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        
        classEnrollRef = Database.database().reference().child("students").child(classProtocol.getFirebasePathWithSchoolYear())
        
        updateTableviewVisibilityBasedOnSearchResult()
        
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

        startLoading()
        fetchData {
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.reloadData()
                self.stopLoading()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    func showAddYourInfoBtnIfYouAreNotInTheClass(){
        chatBtn.isEnabled = false
        addYourselfBtn.isHidden = false
        
        for student in students{
            if(student.uid == CurrentUserHelper.getUid()){
                addYourselfBtn.isHidden = true
                chatBtn.isEnabled = true
            }
        }
    }    
    
    func fetchData(completionHandler: @escaping () -> Void){
        students.removeAll()
        searchStudents.removeAll()
        
        classEnrollRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let uid = (snap as! DataSnapshot).key 
                
                AllUserHelper.getAnyStudentFromDatabase(uid: uid, completionHandler: { (student) in
                    self.students.append(student)
                    self.searchStudents.append(student)
                    
                    if(self.students.count == snapshot.children.allObjects.count){
                        completionHandler()
                    }
                })
            }
            
            if(snapshot.children.allObjects.count == 0){
                completionHandler()
            }
        }
    }
    
    func reloadData(){
        self.searchStudents = self.students
        self.tableview.reloadData()
        self.updateTableviewVisibilityBasedOnSearchResult()
        self.showAddYourInfoBtnIfYouAreNotInTheClass()
    }
    


    @IBAction func addYourselfBtnPressed(_ sender: Any) {
        if(!CurrentUserHelper.hasEnoughDataInFireBase()){
            performSegue(withIdentifier: "ClassDetailToAddYourInfoSegue", sender: self)
        }
        else{
            enrollUserToClass()
            CurrentUserHelper.addEnrollment(classD: classProtocol)
        }
    }
    
    func enrollUserToClass(){
        classEnrollRef.child(CurrentUserHelper.getUid()).setValue(CurrentUserHelper.getFullname()) { (error, ref) in
            if(error == nil){
                DispatchQueue.main.async {
                    self.students.append(CurrentUserHelper.getStudent())
                    self.reloadData()
                }
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

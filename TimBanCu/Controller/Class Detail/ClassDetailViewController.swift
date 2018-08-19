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

    var finishedLoadingInitialTableCells = false

    
    // backend
    var students = [Student]()
    var searchStudents = [Student]()
    var selectedStudent:Student!
    
    //no result
    var noResultLabel = NoResultLabel(type: Type.Student)
    
    //ui
    let customSelectionColorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0, alpha: 0.2)
        return view
    }()
    
    let animatedEmoticon: LOTAnimationView = {
        let animation = LOTAnimationView(name: "empty_list")
        animation.contentMode = .scaleAspectFill
        animation.loopAnimation = true
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    var searchTFUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0).withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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

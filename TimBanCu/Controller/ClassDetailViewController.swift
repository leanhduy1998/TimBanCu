//
//  ClassDetailViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/16/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ClassDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var addYourselfBtn: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func unwindToClassDetailViewController(segue:UIStoryboardSegue) { }
    
    
    var students = [Student]()
    var searchStudents = [Student]()
    
    var selectedSchool:School!
    var selectedClassNumber: String!
    var selectedClassName:ClassName!

    //no result
    var noResultLabel = UILabel()
    
    var studentInClassRef:DatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTableviewVisibilityBasedOnSearchResult()
        studentInClassRef = Database.database().reference().child("students").child(selectedSchool.name).child(selectedClassNumber).child(selectedClassName.className)
        
        startLoading()
        reloadData {
            DispatchQueue.main.async {
                self.searchStudents = self.students
                self.tableview.reloadData()
                self.stopLoading()
                self.updateTableviewVisibilityBasedOnSearchResult()
            }
        }
        
    }
    
    func startLoading(){
        tableview.isHidden = true
        searchTF.isHidden = true
        addYourselfBtn.isEnabled = true
        activityIndicator.isHidden = false
        
        activityIndicator.startAnimating()
    }
    
    func stopLoading(){
        UIView.animate(withDuration: 1) {
            self.tableview.isHidden = false
            self.searchTF.isHidden = false
            self.activityIndicator.isHidden = true
            
            if(self.students.count != 0 && UserHelper.student==nil){
                self.addYourselfBtn.isHidden = false
            }
            else{
                self.addYourselfBtn.isHidden = true
            }
        }
        activityIndicator.stopAnimating()
    }
    
    func reloadData(completionHandler: @escaping () -> Void){
        students.removeAll()
        searchStudents.removeAll()
        
        studentInClassRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let uid = (snap as! DataSnapshot).key as! String
                let fullname = (snap as! DataSnapshot).value as! String
               
                
                let student = Student()
                student.uid = uid
                student.fullName = fullname
                Database.database().reference().child("publicUserProfile").child(uid).observeSingleEvent(of: .value, with: { (publicSS) in
                    for snap in publicSS.children{
                        let key = (snap as! DataSnapshot).key as! String
                        
                        if(key == "birthYear"){
                            let birthYear = (snap as! DataSnapshot).value as! String
                            student.birthYear = birthYear
                        }
                        else if(key == "images"){
                            let images = (snap as! DataSnapshot).value as! [String]
                            
                            student.imageUrls = images
                        }
                        else if(key == "phoneNumber"){
                            let phoneNumber = (snap as! DataSnapshot).value as! String
                            student.phoneNumber = phoneNumber
                        }
                        else if(key == "email"){
                            let email = (snap as! DataSnapshot).value as! String
                            student.email = email
                        }
                    }
                    
                    if(student.isStudentInfoCompleted()){
                        self.students.append(student)
                        completionHandler()
                    }
                })
                
                Database.database().reference().child("privateUserProfile").child(uid).observeSingleEvent(of: .value, with: { (privateSS) in
                    for snap in privateSS.children{
                        let key = (snap as! DataSnapshot).key as! String
                        if(key == "phoneNumber"){
                            let phoneNumber = (snap as! DataSnapshot).value as! String
                            student.phoneNumber = phoneNumber
                        }
                        else if(key == "email"){
                            let email = (snap as! DataSnapshot).value as! String
                            student.email = email
                        }
                    }
                    if(student.isStudentInfoCompleted()){
                        self.students.append(student)
                        completionHandler()
                    }
                })
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        setupNoResultLabel(topViewY: searchTF.bounds.origin.y, topViewHeight: searchTF.frame.height)
        view.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassDetailTableViewCell") as? ClassDetailTableViewCell
        
        let student = searchStudents[indexPath.row]
        
        cell?.nameLabel.text = student.fullName
        
        return cell!
    }

    @IBAction func addYourselfBtnPressed(_ sender: Any) {
        if(UserHelper.student == nil){
            
        }
        else{
            performSegue(withIdentifier: "ClassDetailToAddYourInfoSegue", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddYourInfoViewController{
            destination.selectedSchool = selectedSchool
            destination.selectedClassNumber = selectedClassNumber
            destination.selectedClassName = selectedClassName
        }
    }

}

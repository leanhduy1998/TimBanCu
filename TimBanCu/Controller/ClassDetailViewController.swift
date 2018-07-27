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
    var selectedStudent:Student!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTableviewVisibilityBasedOnSearchResult()
        studentInClassRef = Database.database().reference().child("students").child(selectedSchool.name).child(selectedClassNumber).child(selectedClassName.className)
        
        startLoading()
        fetchData {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    func showAddYourInfoBtnIfYouAreNotInTheClass(){
        if(UserHelper.uid == nil){
            addYourselfBtn.isHidden = false
            return
        }
        
        for student in students{
            if(student.uid == UserHelper.uid){
                addYourselfBtn.isHidden = true
            }
        }
    }    
    
    func fetchData(completionHandler: @escaping () -> Void){
        students.removeAll()
        searchStudents.removeAll()
        
        studentInClassRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let uid = (snap as! DataSnapshot).key 
                
                UserHelper.getStudentFromDatabase(uid: uid, completionHandler: { (student) in
                    self.students.append(student)
                    self.searchStudents.append(student)
                    
                    if(self.students.count == snapshot.children.allObjects.count){
                        completionHandler()
                    }
                })
            }
        }
    }
    
    func reloadData(){
        self.searchStudents = self.students
        self.tableview.reloadData()
        self.stopLoading()
        self.updateTableviewVisibilityBasedOnSearchResult()
        self.showAddYourInfoBtnIfYouAreNotInTheClass()
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedStudent = searchStudents[indexPath.row]
        performSegue(withIdentifier: "ClassDetailToStudentDetail", sender: self)
    }

    @IBAction func addYourselfBtnPressed(_ sender: Any) {
        if(UserHelper.student == nil){
            performSegue(withIdentifier: "ClassDetailToAddYourInfoSegue", sender: self)
        }
        else{
            Database.database().reference().child("students").child(selectedSchool.name).child(selectedClassNumber).child(selectedClassName.className).child(UserHelper.uid).setValue(UserHelper.student.fullName) { (error, ref) in
                if(error == nil){
                    DispatchQueue.main.async {
                        self.students.append(UserHelper.student)
                        self.reloadData()
                    }
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddYourInfoViewController{
            destination.selectedSchool = selectedSchool
            destination.selectedClassNumber = selectedClassNumber
            destination.selectedClassName = selectedClassName
        }
        if let destination = segue.destination as? StudentDetailViewController{
            destination.selectedStudent = selectedStudent 
        }
    }

}

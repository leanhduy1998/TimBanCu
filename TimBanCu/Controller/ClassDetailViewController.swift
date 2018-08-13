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
    
    
    // backemd
    
    var students = [Student]()
    var searchStudents = [Student]()
    
    var classDetail:ClassDetail!
    var selectedStudent:Student!
    
    var selectedYear:String!

    //no result
    var noResultLabel = NoResultLabel(text: "Chưa có học sinh nào.\n Bạn có muốn thông tin của mình?")
    
    
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
    var studentInClassRef:DatabaseReference!
    
    override func viewDidLoad() {
        studentInClassRef = Database.database().reference().child("students").child(classDetail.schoolName).child(classDetail.classNumber).child(classDetail.className).child(selectedYear)
        
        customizeSearchTF()
        setUpAnimatedEmoticon()
        tableview.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableview.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noResultLabel.isHidden = true
        animatedEmoticon.isHidden = true
        
        updateTableviewVisibilityBasedOnSearchResult()
                
        startLoading()
        fetchData {
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    func showAddYourInfoBtnIfYouAreNotInTheClass(){
        chatBtn.isEnabled = false
        addYourselfBtn.isHidden = false
      
        
        if(UserHelper.student == nil){
            addYourselfBtn.isHidden = false
            return
        }
        
        for student in students{
            if(student.uid == UserHelper.uid){
                addYourselfBtn.isHidden = true
                chatBtn.isEnabled = true
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
            
            if(snapshot.children.allObjects.count == 0){
                completionHandler()
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
        cell?.selectedBackgroundView = customSelectionColorView
        
        cell?.nameLabel!.hero.id = "\(student.fullName)"
        cell?.imageview!.hero.id = "\(student.fullName)image"
        cell?.nameLabel!.hero.modifiers = [.arc]
        cell?.imageview!.hero.modifiers = [.arc]
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
            Database.database().reference().child("students").child(classDetail.schoolName).child(classDetail.classNumber).child(classDetail.className).child(classDetail.classYear).child(UserHelper.uid).setValue(UserHelper.student.fullName) { (error, ref) in
                if(error == nil){
                    DispatchQueue.main.async {
                        self.students.append(UserHelper.student)
                        self.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func chatBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "ClassDetailToChatSegue", sender: self)
    }
    
    func updateTableviewVisibilityBasedOnSearchResult(){
        if(searchStudents.count == 0){
            noResultLabel.isHidden = false
            tableview.isHidden = true
            animatedEmoticon.isHidden = false
            animatedEmoticon.play()
        }
        else{
            noResultLabel.isHidden = true
            tableview.isHidden = false
            animatedEmoticon.isHidden = true
            animatedEmoticon.stop()
        }
    }
    
    func startLoading(){
        tableview.isHidden = true
        searchTF.isHidden = true
        addYourselfBtn.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoading(){
        UIView.animate(withDuration: 1) {
            self.tableview.isHidden = false
            self.searchTF.isHidden = false
            self.activityIndicator.isHidden = true
        }
        activityIndicator.stopAnimating()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddYourInfoViewController{
            destination.classDetail = classDetail
        }
        if let destination = segue.destination as? StudentDetailViewController{
            destination.student = selectedStudent
        }
        
        if let destination = segue.destination as? ChatViewController{
            destination.classDetail = classDetail
        }
        
    }

}

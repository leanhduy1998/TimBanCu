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

class SchoolViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    var schoolModels = [School]()
    var searchSchoolModels = [School]()
    
    var selectedSchoolType:String!
    var selectedSchool:School!
    
    var noResultLabel = NoResultLabel(type: Type.School)
<<<<<<< HEAD
    var noResultAddNewSchoolBtn = NoResultButton(title: "Thêm Trường Mới")

    var finishedLoadingInitialTableCells = false
    
    var searchTFUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = themeColor.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var searchUnderlineHeightAnchor: NSLayoutConstraint?
    
    let customSelectionColorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0, alpha: 0.2)
        return view
    }()
=======
    var noResultAddNewSchoolBtn = NoResultButton(type: Type.School)
>>>>>>> UI-Design
    
    let animatedEmoticon: LOTAnimationView = {
        let animation = LOTAnimationView(name: "empty_list")
        animation.contentMode = .scaleAspectFill
        animation.loopAnimation = true
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
<<<<<<< HEAD
    //alert
    var addNewSchoolAlert:UIAlertController!
    var addNewSchoolCompletedAlert:UIAlertController!
    var schoolAlreadyExistAlert:UIAlertController!
    
    //database
    var tieuhocQuery:DatabaseQuery!
    var thcsQuery:DatabaseQuery!
    var thptQuery:DatabaseQuery!
    var daihocQuery:DatabaseQuery!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSchoolFirebaseReferences()
    }
=======
    var finishedLoadingInitialTableCells = false
    
    //alert
    var addNewSchoolAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    var addNewSchoolCompletedAlert = UIAlertController(title: "Trường của bạn đã được thêm!", message: "", preferredStyle: .alert)
    let schoolAlreadyExistAlert = UIAlertController(title: "Trường của bạn đã có trong danh sách!", message: "Vui Lòng Chọn Trường Trong Danh Sách Chúng Tôi Hoặc Thêm Trường Mới", preferredStyle: .alert)
    
    
    //database
    let tieuhocQueryRef = Database.database().reference().child("schools").queryOrdered(byChild: "type").queryEqual(toValue : "th")
    let thcsQueryRef = Database.database().reference().child("schools").queryOrdered(byChild: "type").queryEqual(toValue : "thcs")
    let thptQueryRef = Database.database().reference().child("schools").queryOrdered(byChild: "type").queryEqual(toValue : "thpt")
    let daihocQueryRef = Database.database().reference().child("schools").queryOrdered(byChild: "type").queryEqual(toValue : "dh")

>>>>>>> UI-Design
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setupAlerts()
        setUpAnimatedEmoticon()
        setupNoResultLabelAndButton()
        
<<<<<<< HEAD
        setupNoResultLabelAndButton()
        
        updateItemsVisibilityBasedOnSearchResult()
=======
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
>>>>>>> UI-Design
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
        
        if (self.isMovingFromParentViewController) {
            navigationController?.hero.isEnabled = true
            navigationController?.hero.navigationAnimationType = .fade
        } 
    }
    
    @objc func addNewSchoolBtnPressed(_ sender: UIButton?) {
        if(selectedSchoolType == "th"){
            addNewSchoolAlert.title = "Thêm Trường Tiểu Học Mới"
        }
        else if(selectedSchoolType == "thcs"){
            addNewSchoolAlert.title = "Thêm Trường Trung Học Cơ Sở Mới"
        }
        else if(selectedSchoolType == "thpt"){
            addNewSchoolAlert.title = "Thêm Trường Trung Học Phổ Thông Mới"
        }
        else if(selectedSchoolType == "dh"){
            addNewSchoolAlert.title = "Thêm Trường Đại Học Mới"
        }
        
        self.present(addNewSchoolAlert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func fetchData(){
        schoolModels.removeAll()
        searchSchoolModels.removeAll()
        
        if(selectedSchoolType == "th"){
            tieuhocGetQuery {
                self.updateUIFromData()
            }
        }
        else if(selectedSchoolType == "thcs"){
            thcsGetQuery {
                self.updateUIFromData()
            }
        }
        else if(selectedSchoolType == "thpt"){
            thptGetQuery {
                self.updateUIFromData()
            }
        }
        else{
            daihocGetQuery {
                self.updateUIFromData()
            }
        }
    }
    
    func addSchoolToSchoolList(schoolName:String){
        let school = School(name: schoolName, address: "?", type: self.selectedSchoolType, uid: CurrentUserHelper.getUid())
        
        self.addSchoolToLocal(school: school)
        
        self.addSchoolToDatabase(school: school, completionHandler: { (err, ref) in
            DispatchQueue.main.async {
                if(err == nil){
                    self.present(self.addNewSchoolCompletedAlert, animated: true, completion: nil)
                }
                else{
                    if(err?.localizedDescription == "Permission denied") {
                        self.present(self.schoolAlreadyExistAlert, animated: true, completion: nil)
                    }
                }
            }
            
        })
    }
    
    private func addSchoolToDatabase(school:School,completionHandler: @escaping (_ err:Error?, _ ref:DatabaseReference)->Void){
        Database.database().reference().child("schools").child(school.name).setValue(school.getObjectValueAsDic(), withCompletionBlock: completionHandler)
    }
    
    private func addSchoolToLocal(school:School){
        schoolModels.append(school)
        searchSchoolModels.append(school)
        tableview.reloadData()
        updateItemsVisibilityBasedOnSearchResult()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassViewController{
            if(selectedSchoolType == "th"){
                destination.classes = ["Lớp 1", "Lớp 2", "Lớp 3", "Lớp 4", "Lớp 5"]
            }
            else if(selectedSchoolType == "thcs"){
                destination.classes = ["Lớp 6", "Lớp 7", "Lớp 8", "Lớp 9"]
            }
            else if(selectedSchoolType == "thpt"){
                destination.classes = ["Lớp 10", "Lớp 11", "Lớp 12"]
            }
            destination.school = selectedSchool
        }
        if let destination = segue.destination as? MajorViewController{
            destination.school = selectedSchool
        }
    }
}

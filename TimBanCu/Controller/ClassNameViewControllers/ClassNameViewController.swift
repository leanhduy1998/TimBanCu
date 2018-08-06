//
//  ClassDetailViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/9/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ClassNameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    var school:School!
    var classNumber: String!
    var selectedClassDetail:ClassDetail!
    
    //database
    var schoolAllClassesDetailsQuery:DatabaseQuery!
    
    
    //no result
    var noResultLabel = NoResultLabel(text: "Chưa có lớp. Bạn có muốn thêm lớp?               Ví dụ: 10A11")
    var noResultAddNewClassBtn = NoResultButton(title: "Thêm Lớp Mới")
    
    //tableview
    var classDetails = [ClassDetail]()
    
    //alert
    var addNewClassAlert = UIAlertController(title: "Thêm Lớp Mới", message: "", preferredStyle: .alert)
    
    
    let customSelectionColorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0, alpha: 0.2)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNoResultLabelAndButton()
        setupAlerts()
    }
    
    override func viewDidLayoutSubviews() {
        setupNoResultLabelAndButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func fetchData(){
        classDetails.removeAll()
        
         Database.database().reference().child("classes").child(school.name).child(classNumber).observeSingleEvent(of: .value) { (snapshot) in
            
            
            for snap in snapshot.children{
                print(snap)
                
                let className = (snap as! DataSnapshot).key as! String
                
                let classYearAndDic = (snap as! DataSnapshot).value as! [String:[String:String]]
                
                for(year,dic) in classYearAndDic{
                    let uid = dic["uid"] as! String
                    
                    let classDetail = ClassDetail(classNumber: self.classNumber, uid: uid, schoolName: self.school.name, className: className, classYear: year)
                    
                     self.classDetails.append(classDetail)
                }
            }
            
            DispatchQueue.main.async {
                self.tableview.reloadData()
                self.updateTableviewVisibilityBasedOnSearchResult()
            }
        }
        
        /*schoolAllClassesDetailsQuery = classesDetailRef.queryOrdered(byChild: "schoolName").queryEqual(toValue : school.name)
        schoolAllClassesDetailsQuery.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let value = (snap as! DataSnapshot).value as? [String:Any]
                
                let classNumber = value!["classNumber"] as! String
                
                if(classNumber == self.classNumber){
                    let uid = value!["uid"] as! String
                    let schoolName = value!["schoolName"] as! String
                    let className = value!["className"] as! String
                    
                    let classDetailModel = ClassDetail(classNumber: classNumber, uid: uid, schoolName: schoolName, className: className)
                    
         
                }
            }
            
         
        }*/
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassNameTableViewCell") as? ClassNameTableViewCell
        cell?.classDetailViewModel = ClassNameViewModel(classDetail: classDetails[indexPath.row])
        cell?.selectedBackgroundView = customSelectionColorView
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedClassDetail = classDetails[indexPath.row]
        performSegue(withIdentifier: "ClassNameToClassYear", sender: self)
    }
    
    @objc func addNewClassDetailBtnPressed(_ sender: UIButton?) {
        self.present(addNewClassAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassYearViewController{
            destination.classDetail = selectedClassDetail
        }
    }
    

}

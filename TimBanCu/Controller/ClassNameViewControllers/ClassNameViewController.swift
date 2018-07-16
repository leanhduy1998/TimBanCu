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
    
    var selectedSchool:School!
    var selectedClass: String!
    
    //database
    var schoolAllClassesDetailsQuery:DatabaseQuery!
    var classesDetailRef = Database.database().reference().child("classes")
    
    //no result
    var noResultLabel = UILabel()
    var noResultAddNewClassBtn = UIButton()
    
    //tableview
    var classDetails = [ClassName]()
    var searchClassDetails = [ClassName]()
    
    //alert
    var addNewClassAlert = UIAlertController(title: "Thêm Lớp Mới", message: "", preferredStyle: .alert)
    var addNewClassCompletedAlert = UIAlertController(title: "Lớp của bạn đã được thêm!", message: "", preferredStyle: .alert)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNoResultLabelAndButton(topViewY: 0, topViewHeight: 20)
        setupAlerts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func fetchData(){
        schoolAllClassesDetailsQuery = classesDetailRef.queryOrdered(byChild: "schoolName").queryEqual(toValue : selectedSchool.name)
        schoolAllClassesDetailsQuery.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let value = (snap as! DataSnapshot).value as? [String:Any]
                
                let classNumber = value!["classNumber"] as! String
                let uid = value!["uid"] as! String
                let schoolName = value!["schoolName"] as! String
                let className = value!["className"] as! String
                
                let classDetailModel = ClassName(classNumber: classNumber, uid: uid, schoolName: schoolName, className: className)
                
                self.classDetails.append(classDetailModel)
            }
            
            DispatchQueue.main.async {
                self.searchClassDetails = self.classDetails
                self.tableview.reloadData()
                self.updateTableviewVisibilityBasedOnSearchResult()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchClassDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassDetailTableViewCell") as? ClassDetailTableViewCell
        cell?.classDetailViewModel = ClassNameViewModel(classDetail: searchClassDetails[indexPath.row])
        
        return cell!
    }
    
    @objc func addNewClassDetailBtnPressed(_ sender: UIButton?) {
        self.present(addNewClassAlert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

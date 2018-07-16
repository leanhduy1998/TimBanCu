//
//  ClassDetailViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/9/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ClassDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var addNewClassAlert = UIAlertController(title: "Thêm Lớp Mới", message: "", preferredStyle: .alert)
    var addNewClassCompletedAlert = UIAlertController(title: "Lớp của bạn đã được thêm!", message: "", preferredStyle: .alert)
    
    var noResultLabel = UILabel()
    var noResultAddNewClassBtn = UIButton()
    
    let classesDetailRef = Database.database().reference().child("classes")
    
    var selectedSchool:School!
    
    var classDetails = [ClassDetail]()
    var searchClassDetails = [ClassDetail]()
    
    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNoResultLabelAndButton(topViewY: 0, topViewHeight: 20)
        setupAlerts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchClassDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassDetailTableViewCell") as? ClassDetailTableViewCell
        cell?.classDetailViewModel = ClassDetailViewModel(classDetail: searchClassDetails[indexPath.row])
        
        return cell!
    }
    
    @objc func addNewClassDetailBtnPressed(_ sender: UIButton?) {
        
        
        //self.present(addNewSchoolAlert, animated: true, completion: nil)
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

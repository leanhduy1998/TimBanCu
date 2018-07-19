//
//  ClassDetailViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/16/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class ClassDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    @IBAction func unwindToClassDetailViewController(segue:UIStoryboardSegue) { }
    
    
    var students = [Student]()
    var searchStudents = [Student]()
    
    
    @IBOutlet weak var addYourselfBtn: UIButton!
    
   // var addYourselfAlert = UIAlertController(title: "Thêm Thông Tin Cá Nhân", message: "Thêm Thông Tin Để Bạn Cùng Lớp Dễ Liên Lạc Hơn!", preferredStyle: .alert)
    
    //no result
    var noResultLabel = UILabel()
    var noResultAddYourInfoBtn = UIButton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTableviewVisibilityBasedOnSearchResult()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(students.count != 0 && UserHelper.student==nil){
            addYourselfBtn.isHidden = false
        }
        else{
            addYourselfBtn.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        setupNoResultLabelAndButton(topViewY: searchTF.bounds.origin.y, topViewHeight: searchTF.frame.height)
        view.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassDetailTableViewCell") as? ClassDetailTableViewCell
        return cell!
    }

    @IBAction func addYourselfBtnPressed(_ sender: Any) {
        if(UserHelper.student == nil){
            
        }
    }
    
    @objc func addYourInfoBtnPressed(_ sender: UIButton?) {
        performSegue(withIdentifier: "ClassDetailToAddYourInfoSegue", sender: self)
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

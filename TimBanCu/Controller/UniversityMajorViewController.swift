//
//  UniversityMajorViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/2/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UniversityMajorViewController: UIViewController {

    var noResultLabel = NoResultLabel(text: "Không có kết quả. Bạn vui lòng điền có dấu. Bạn có muốn thêm tên khoa mới? Ví Dụ: Khoa Kinh Tế")
    var noResultAddNewMajorBtn = NoResultButton(title: "Thêm Khoa Mới")
    
    var addNewSchoolAlert = UIAlertController(title: "Thêm Khoa Mới", message: "", preferredStyle: .alert)
    var addNewSchoolCompletedAlert = UIAlertController(title: "Trường của bạn đã được thêm!", message: "", preferredStyle: .alert)
    var majorAlreadyExistAlert = UIAlertController(title: "Trường của bạn đã có trong danh sách!", message: "Vui Lòng Chọn Trường Trong Danh Sách Chúng Tôi Hoặc Thêm trường", preferredStyle: .alert)
    
    var school:School!
    
    var majors = [MajorDetail]()
    var searchMajors = [MajorDetail]()
    
    var selectedMajor:MajorDetail!
    
    @IBOutlet weak var tableview: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        setupNoResultLabelAndButton()
    }

    func setupNoResultLabelAndButton(){
        view.addSubview(noResultLabel)
        view.addSubview(noResultAddNewMajorBtn)
        
        view.bringSubview(toFront: noResultLabel)
        view.bringSubview(toFront: noResultAddNewMajorBtn)
        
        noResultLabel.text = ""
        noResultLabel.textColor = UIColor.darkGray
        noResultLabel.textAlignment = .center
        noResultLabel.numberOfLines = 2
        noResultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        noResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        noResultLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        noResultLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        noResultAddNewMajorBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultAddNewMajorBtn.topAnchor.constraint(equalTo: noResultLabel.bottomAnchor, constant: 20).isActive = true
        noResultAddNewMajorBtn.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        noResultAddNewMajorBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        noResultAddNewMajorBtn.addTarget(self, action: #selector(self.addNewMajorBtnPressed(_:)), for: .touchUpInside)
    }
    
    @objc func addNewMajorBtnPressed(_ sender: UIButton?) {
        self.present(addNewSchoolAlert, animated: true, completion: nil)
    }
    
    func setupAlerts(){
        setupAddNewSchoolAlert()
        setupAddNewSchoolCompletedAlert()
        
        setupSchoolAlreadyExistAlert()
    }
    
    private func setupSchoolAlreadyExistAlert(){
        majorAlreadyExistAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak majorAlreadyExistAlert] (_) in
            self.majorAlreadyExistAlert.dismiss(animated: true, completion: nil)
        }))
    }
    
    private func setupAddNewSchoolAlert(){
        addNewSchoolAlert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { [weak addNewSchoolAlert] (_) in
            addNewSchoolAlert?.dismiss(animated: true, completion: nil)
        }))
        
        addNewSchoolAlert.addTextField { (textField) in
            textField.placeholder = "Tên Khoa"
        }
        
        addNewSchoolAlert.addAction(UIAlertAction(title: "Thêm", style: .default, handler: { [weak addNewSchoolAlert] (_) in
            let textField = addNewSchoolAlert?.textFields![0] // Force unwrapping because we know it exists.
            let majorName = textField?.text
            if(!(majorName?.isEmpty)!){
                let major = MajorDetail(uid: UserHelper.uid, schoolName: self.school.name, majorName: majorName!)
                
                
                DispatchQueue.main.async {
                    
                    let schoolsRef = Database.database().reference().child("schools")
                    schoolsRef.child(self.school.name!).setValue(major.getObjectValueAsDic(), withCompletionBlock: { (err, ref) in
                        
                        if(err == nil){
                            DispatchQueue.main.async {
                                self.majors.append(major)
                                
                                self.searchMajors.append(major)
                                self.tableview.reloadData()
                                self.updateTableviewVisibilityBasedOnSearchResult()
                                self.present(self.addNewSchoolCompletedAlert, animated: true, completion: nil)
                                
                            }
                        }
                        else{
                            if(err?.localizedDescription == "Permission denied") {
                                self.present(self.majorAlreadyExistAlert, animated: true, completion: nil)
                                
                            }
                        }
                    })
                }
            }
        }))
    }
    
    private func setupAddNewSchoolCompletedAlert(){
        addNewSchoolCompletedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak addNewSchoolCompletedAlert] (_) in
            addNewSchoolCompletedAlert?.dismiss(animated: true, completion: nil)
        }))
    }
    
    func updateTableviewVisibilityBasedOnSearchResult(){
        if(searchMajors.count == 0){
            noResultLabel.isHidden = false
            noResultAddNewMajorBtn.isHidden = false
            tableview.isHidden = true
        }
        else{
            noResultLabel.isHidden = true
            noResultAddNewMajorBtn.isHidden = true
            tableview.isHidden = false
            tableview.reloadData()
        }
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

extension UniversityMajorViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMajors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MajorTableViewCell") as! MajorTableViewCell
        cell.major = searchMajors[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMajor = searchMajors[indexPath.row]
        performSegue(withIdentifier: "MajorToClassYearSegue", sender: self)
    }
    
    
}

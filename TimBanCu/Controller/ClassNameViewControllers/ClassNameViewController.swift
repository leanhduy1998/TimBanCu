//
//  ClassDetailViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/9/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Lottie

class ClassNameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    var school:School!
    var classNumber: String!
    var selectedClassDetail:ClassDetail!
    
    var finishedLoadingInitialTableCells = false
    
    //database
    var schoolAllClassesDetailsQuery:DatabaseQuery!
    
    
    //no result
    var noResultLabel = NoResultLabel(text: "Chưa có lớp. Bạn có muốn thêm lớp?\n Ví dụ: 10A11")
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
    
    let animatedEmoticon: LOTAnimationView = {
        let animation = LOTAnimationView(name: "empty_list")
        animation.contentMode = .scaleAspectFill
        animation.loopAnimation = true
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAnimatedEmoticon()
        setupNoResultLabelAndButton()
        setupAlerts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        noResultLabel.isHidden = true
        noResultAddNewClassBtn.isHidden = true
        animatedEmoticon.isHidden = true
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var lastInitialDisplayableCell = false
        
        if classDetails.count > 0 && !finishedLoadingInitialTableCells {
            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
                let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
                lastInitialDisplayableCell = true
            }
        }
        
        if !finishedLoadingInitialTableCells {
            
            if lastInitialDisplayableCell {
                finishedLoadingInitialTableCells = true
            }
            cell.transform = CGAffineTransform(translationX: 0, y: tableview.rowHeight / 2)
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            }, completion: nil)
        }
        
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

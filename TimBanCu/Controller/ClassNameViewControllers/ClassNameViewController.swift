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
    
    // From previous class
    var school:School!
    var classNumber: String!
    //
    
    var selectedClassDetail:ClassDetail!
    
    //database
    var schoolAllClassesDetailsQuery:DatabaseQuery!
    
    
    //no result
    var noResultLabel = NoResultLabel(type: Type.Class)
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
        animatedEmoticon.isHidden = true
    }
    
    func fetchData(){
        classDetails.removeAll()
        
         Database.database().reference().child("classes").child(school.name).child(classNumber).observeSingleEvent(of: .value) { (snapshot) in
            
            
            for snap in snapshot.children{
                let className = (snap as! DataSnapshot).key as! String
                
                let classDic = (snap as! DataSnapshot).value as! [String:[String:String]]
                
                for(_,dic) in classDic{
                    // there could be multiple class years
                    let classDetail = ClassDetail(classNumber: self.classNumber, uid: "?", schoolName: self.school.name, className: className, classYear: "?")
                    
                     self.classDetails.append(classDetail)
                }
            }
            
            DispatchQueue.main.async {
                self.tableview.reloadData()
                self.updateTableviewVisibilityBasedOnSearchResult()
            }
        }
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

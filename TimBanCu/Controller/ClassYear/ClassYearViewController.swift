//
//  ClassYearViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/1/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ClassYearViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var classProtocol:ClassProtocol!
    
    var years = [String]()
    var selectedYear:String!
    
    var addNewClassCompletedAlert:UIAlertController!
    var classAlreadyExistAlert:UIAlertController!
    
    let customSelectionColorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0, alpha: 0.2)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAlerts()
        tableview.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupManualYears()
    }
    
    func setupManualYears(){
        for firstTwoDigits in 19...21{
            for lastTwoDigits in 0...99{
                var string = ""
                
                string.append("Năm ")
                string.append("\(firstTwoDigits)")
                if(lastTwoDigits<10){
                    string.append("0")
                }
                string.append("\(lastTwoDigits)")
                
                if(string == "Năm 2019"){
                    return
                }
                
                years.append(string)
            }
        }
    }
    
    func checkIfClassYearExist(completionHandler: @escaping (_ exist:Bool, _ uid:String) -> Void){
        
        Database.database().reference().child("classes").child(classProtocol.getFirebasePathWithoutSchoolYear()).child(selectedYear).observeSingleEvent(of: .value) { (snapshot) in
            
            let classValue = (snapshot as! DataSnapshot).value as? [String:String]
            
            if(classValue == nil){
                completionHandler(false, "")
            }
            else{
                let uid = classValue!["uid"]
                completionHandler(true, uid!)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassDetailViewController{
            destination.classProtocol = classProtocol
        }
    }
}


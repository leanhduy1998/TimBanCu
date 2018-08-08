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
    
    var classDetail:ClassDetail!
    var majorDetail:MajorDetail!
    
    var years = [String]()
    var selectedYear:String!
    
    var addNewClassCompletedAlert:UIAlertController!
    var classAlreadyExistAlert:UIAlertController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupAlerts()
        tableview.reloadData()
    }
    
    func setupData(){
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassDetailViewController{
            destination.classDetail = classDetail
            destination.selectedYear = selectedYear
        }
    }
}

extension ClassYearViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return years.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassYearTableViewCell") as! ClassYearTableViewCell
        cell.yearLabel.text = years[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedYear = years[indexPath.row]
        
        if(classDetail != nil){
            if(classDetail.classYear == "Năm ?"){
                classDetail.classYear = selectedYear
                
                classDetail.writeClassDetailToDatabase { (err, ref) in
                    DispatchQueue.main.async {
                        
                        if(err == nil){
                            self.present(self.addNewClassCompletedAlert, animated: true, completion: nil)
                        }
                        else if(err?.localizedDescription == "Permission denied") {
                                self.present(self.classAlreadyExistAlert, animated: true, completion: nil)
                            
                        }
                    }
                }
            }
            else{
                performSegue(withIdentifier: "YearToClassDetailSegue", sender: self)
            }
        }
        else if(majorDetail != nil){
            if(majorDetail.majorYear == "Năm ?"){
                majorDetail.majorYear = selectedYear
                
                majorDetail.writeMajorDetailToDatabase { (err, ref) in
                    DispatchQueue.main.async {
                        
                        if(err == nil){
                            self.present(self.addNewClassCompletedAlert, animated: true, completion: nil)
                        }
                        else if(err?.localizedDescription == "Permission denied") {
                            self.present(self.classAlreadyExistAlert, animated: true, completion: nil)
                            
                        }
                    }
                }
            }
            else{
                performSegue(withIdentifier: "YearToClassDetailSegue", sender: self)
            }
        }
        
        
    }
    
}

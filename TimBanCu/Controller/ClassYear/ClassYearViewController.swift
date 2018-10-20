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
    var selectedYear:String!
    
    private var uiController:ClassYearUIController!
    private var controller:ClassYearController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = ClassYearController()
        
        uiController = ClassYearUIController(viewcontroller: self, tableview: tableview, years: controller.years, classProtocol: classProtocol) { [weak self] (selectedYear) in
            
            //didSelectYear
            self!.selectedYear = selectedYear
            self!.handleSelectedYear()
        }
    }
    
    func handleSelectedYear(){
        controller.checkIfClassYearExist(selectedYear: selectedYear, classProtocol: classProtocol) { [weak self] (exist, uidIfExist) in
            
            self!.classProtocol.year = self!.selectedYear
            
            if(!exist){
                self!.classProtocol.uid = CurrentUser.getUid()
                
                self!.controller.writeToDatabaseThenShowCompleteAlert(classProtocol: self!.classProtocol, completionHandler: { (uistate) in
                    self!.uiController.state = uistate
                })
            }
            else{
                self!.classProtocol.uid = uidIfExist
                
                DispatchQueue.main.async {
                    self!.performSegue(withIdentifier: "ClassYearToClassDetailSegue", sender: self!)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassDetailViewController{
            destination.classProtocol = classProtocol
        }
    }
}


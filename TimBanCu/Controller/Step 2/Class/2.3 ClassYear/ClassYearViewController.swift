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
    
    var classProtocol:ClassAndMajorProtocol!
    var selectedClassProtocol:ClassAndMajorWithYearProtocol!
    var selectedYear:String!
    
    private var uiController:ClassYearUIController!
    private var controller:ClassYearController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = ClassYearController()
        
        uiController = ClassYearUIController(viewcontroller: self, tableview: tableview, years: controller.years, classOrMajor: classProtocol) { [weak self] (selectedYear) in
            
            //didSelectYear
            self!.selectedYear = selectedYear
            self!.handleSelectedYear()
        }
    }
    
    func handleSelectedYear(){
        if let classs = classProtocol as? Class{
            let classWithYear = ClassWithYear(classs: classs, year: selectedYear)
            selectedClassProtocol = classWithYear
            
        }
        else if let major = classProtocol as? Major{
            let majorWithYear = MajorWithYear(major: major, year: selectedYear)
            selectedClassProtocol = majorWithYear
        }
        
        
    
        classProtocol.classYearExist(year: selectedYear) { [weak self] (exist) in
            if(exist){
                DispatchQueue.main.async {
                    self!.performSegue(withIdentifier: "ClassYearToClassDetailSegue", sender: self!)
                }
            }
            else{
                self!.uiController.state = .Success()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassDetailViewController{
            destination.classProtocol = selectedClassProtocol
        }
    }
}


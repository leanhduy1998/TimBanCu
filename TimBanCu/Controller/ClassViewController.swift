//
//  ElementaryViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/9/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class ClassViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    var classes: [String]!
    var school:School!
    var selectedClass:String!
    
    var tableviewTool:GenericTableViewTool<String, ClassTableViewCell>!
    
    var finishedLoadingInitialTableCells = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableviewTool = GenericTableViewTool(tableview: tableview, items: classes) { (cell, classStr) in
            cell.classLabel.text = classStr
        }
        
        tableviewTool.didSelect = {selectedClass in
            self.selectedClass = selectedClass
            self.performSegue(withIdentifier: "ClassToClassDetailSegue", sender: self)
        }
        
        tableview.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassNameViewController{
            destination.school = school
            destination.classNumber = selectedClass
        }
    }
    

}

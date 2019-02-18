//
//  ElementaryViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/9/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class ClassNumberViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    var school:InstitutionFull!
    var selectedClass:String!
    var educationLevel:EducationLevel!
    var viewModel:ClassNumberViewModel!
    
    private var tableviewTool:GenericTableView<String, ClassTableViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ClassNumberViewModel(educationLevel: educationLevel)
    
        tableviewTool = GenericTableView(tableview: tableview, items: viewModel.classNumbers) { (cell, classStr) in
            cell.classLabel.text = classStr
        }
        
        tableviewTool.didSelect = { [weak self] selectedClass in
            self!.selectedClass = selectedClass
            self!.performSegue(withIdentifier: "ClassToClassDetailSegue", sender: self)
        }
        
        tableview.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassNameViewController{
            destination.institution = school
            destination.classNumber = selectedClass
        }
    }
    

}

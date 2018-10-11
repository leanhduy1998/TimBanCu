//
//  ReportUserViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/10/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class ReportUserViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var students:[Student]!
    var selectedStudent:Student!

    override func viewDidLoad() {
        super.viewDidLoad()

        let genericTableView:GenericTableView<Student,ReportUserTableViewCell> = GenericTableView(tableview: tableview, items: students) { (cell, student) in
            cell.nameLabel.text = student.fullName
        }
        
        genericTableView.didSelect = { [weak self] (student) in
            self?.selectedStudent = student
            self!.performSegue(withIdentifier: "ReportUserToReasonSegue", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ReportReasonViewController{
            destination.student = selectedStudent
        }
    }
 

}

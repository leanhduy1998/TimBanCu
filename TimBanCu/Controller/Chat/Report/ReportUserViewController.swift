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
    
    private var genericTableView:GenericTableView<Student,ReportUserTableViewCell>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var studentIndex = 0
        for student in students{
            if(student.uid == CurrentUser.getUid()){
                students.remove(at: studentIndex)
            }
            studentIndex = studentIndex + 1
        }

        genericTableView = GenericTableView(tableview: tableview, items: students) { (cell, student) in
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

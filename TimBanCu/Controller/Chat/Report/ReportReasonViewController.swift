//
//  ReportReasonViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/10/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ReportReasonViewController: UIViewController {

    var student:Student!
    @IBOutlet weak var tableview: UITableView!
    
    private var ref = Database.database().reference().child("report")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let genericTableView:GenericTableView<ReportReason.Reason,ReportReasonTableViewCell> = GenericTableView(tableview: tableview, items: ReportReason.getAllReason()) { (cell, reason) in
            cell.reasonLabel.text = reason.getString()
        }

        genericTableView.didSelect = { [weak self] reason in
            let alert = 
            
            
            
            var dic = [String:String]()
            
            
            ref.childByAutoId().setValue(<#T##value: Any?##Any?#>)
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

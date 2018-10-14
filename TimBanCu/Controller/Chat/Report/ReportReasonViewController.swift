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
    
    private var reportCompleteAlert:InfoAlert!
    private var reportFailedAlert:InfoAlert!
    
    var genericTableView:GenericTableView<ReportReason.Reason,ReportReasonTableViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reportCompleteAlert = InfoAlert(title: "Báo Cáo Thành Công", message: "Người dùng đã bị ghi vào danh sách báo cáo của chúng tôi", alertType: .Success)
        reportFailedAlert = InfoAlert(title: "Báo Cáo Thất Bại", message: "Bạn vui lòng thử lại", alertType: .Error)
        
        genericTableView = GenericTableView(tableview: tableview, items: ReportReason.getAllReason()) { (cell, reason) in
            cell.reasonLabel.text = reason.getString()
        }

        genericTableView.didSelect = { [weak self] reason in
            
            let title = "Báo Cáo " + reason.getString()
            let message = "Bạn có muốn báo cáo người dùng \(self!.student.fullName) về \(reason.getString())?"
            
            let alert = ConfirmationAlert(title: title, message: message, confirmed: { [weak self] in
                
                var dic = [String:String]()
                dic["uid"] = self!.student.uid
                dic["fullname"] = self!.student.fullName
                dic["reason"] = reason.getString()
                
                self!.ref.childByAutoId().setValue(dic, withCompletionBlock: { (error, _) in
                    if(error == nil){
                        self!.showReportComplete()
                    }
                    else{
                        self!.showReportFailed()
                    }
                })
            })
            alert.showAlert(viewcontroller: self!)
        }
    }
    
    private func showReportComplete(){
        reportCompleteAlert.show(viewcontroller: self)
    }
    
    private func showReportFailed(){
        reportFailedAlert.show(viewcontroller: self)
    }
}

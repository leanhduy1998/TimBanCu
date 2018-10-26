//
//  UserClassesUIController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/6/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class UserClassesUIController:NSObject,UITableViewDelegate,UITableViewDataSource{
    private weak var viewcontroller:UserClassesViewController!
    
    init(viewcontroller:UserClassesViewController){
        super.init()
        self.viewcontroller = viewcontroller
        viewcontroller.tableview.delegate = self
        viewcontroller.tableview.dataSource = self
        viewcontroller.addNavigationBarShadow()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentUser.getEnrolledClasses().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let classDetail = CurrentUser.getEnrolledClasses()[indexPath.row] as? ClassDetail{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserClassTableViewCell") as! UserClassTableViewCell
            cell.viewModel = UserClassViewModel(classDetail: classDetail)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserUniversityTableViewCell") as! UserUniversityTableViewCell
            let majorDetail = CurrentUser.getEnrolledClasses()[indexPath.row] as! MajorDetail
            cell.viewModel = UserUniversityViewModel(majorDetail: majorDetail)
            return cell
        }
    }
    
    func showLoadingView(){
        
    }
    
    func hideLoadingView(){
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoadingView()
        
        let selected = CurrentUser.getEnrolledClasses()[indexPath.row]
    
        
        viewcontroller.selectedClassProtocol = CurrentUser.getEnrolledClasses()[indexPath.row]
        viewcontroller.performSegue(withIdentifier: "UserClassesToClassDetailSegue", sender: viewcontroller)
    }
}



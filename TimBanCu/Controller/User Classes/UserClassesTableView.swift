//
//  UserClassesTableView.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/18/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension UserClassesViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentUser.getEnrolledClasses().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserClassTableViewCell") as! UserClassTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let classDetail = CurrentUser.getEnrolledClasses()[indexPath.row]
        
        let cell = cell as! UserClassTableViewCell
        
        let viewModel = UserClassesViewModel(classDetail: classDetail)
        cell.userClassesViewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedClassDetail = CurrentUser.getEnrolledClasses()[indexPath.row]
        performSegue(withIdentifier: "UserClassesToClassDetailSegue", sender: self)
    }
}

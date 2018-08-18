//
//  ClassDetailTableView.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension ClassDetailViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassDetailTableViewCell") as! ClassDetailTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! ClassDetailTableViewCell
        
        let student = searchStudents[indexPath.row]
        
        cell.nameLabel.text = student.fullName
        cell.selectedBackgroundView = customSelectionColorView
        
        cell.nameLabel!.hero.id = "\(student.fullName)"
        cell.imageview!.hero.id = "\(student.fullName)image"
        cell.nameLabel!.hero.modifiers = [.arc]
        cell.imageview!.hero.modifiers = [.arc]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedStudent = searchStudents[indexPath.row]
        performSegue(withIdentifier: "ClassDetailToStudentDetail", sender: self)
    }
}

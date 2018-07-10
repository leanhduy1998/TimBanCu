//
//  SchoolTableView.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/10/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension SchoolViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchSchoolVMs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolTableViewCell") as? SchoolTableViewCell
        cell?.schoolViewModel = searchSchoolVMs[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSchoolVM = searchSchoolVMs[indexPath.row]
        
        if(selectedSchoolVM.type == "university"){
            
        }
        else{
            performSegue(withIdentifier: "schoolToClassSegue", sender: self)
        }
    }
}

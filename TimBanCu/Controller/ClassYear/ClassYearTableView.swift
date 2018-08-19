//
//  ClassYearTableView.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/18/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension ClassYearViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return years.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassYearTableViewCell") as! ClassYearTableViewCell
        cell.yearLabel.text = years[indexPath.row]
        cell.selectedBackgroundView? = customSelectionColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedYear = years[indexPath.row]
        
        
        checkIfClassYearExist(completionHandler: { exist, uidIfExist  in
            DispatchQueue.main.async {
                if(!exist){
                    self.classProtocol.year = self.selectedYear
                    self.classProtocol.uid = CurrentUserHelper.getUid()
                    self.writeToDatabaseThenShowCompleteAlert(classProtocol: self.classProtocol)
                }
                else{
                    self.classProtocol.uid = uidIfExist
                    self.performSegue(withIdentifier: "ClassYearToClassDetailSegue", sender: self)
                }
            }
        })
    }
    
    private func writeToDatabaseThenShowCompleteAlert(classProtocol:ClassProtocol){
        classProtocol.writeToDatabase { (err, ref) in
            DispatchQueue.main.async {
                if(err == nil){
                    self.present(self.addNewClassCompletedAlert, animated: true, completion: nil)
                }
                else if(err?.localizedDescription == "Permission denied") {
                    self.present(self.classAlreadyExistAlert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
}

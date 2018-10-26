//
//  ClassYearUIController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/2/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class ClassYearUIController{
    private weak var viewcontroller:ClassYearViewController!
    private var genericTableView:GenericTableView<String, ClassYearTableViewCell>!
    private let customSelectionColorView = CustomSelectionColorView()
    private var alerts:ClassYearAlerts!
    
    
    init(viewcontroller:ClassYearViewController, tableview:UITableView,years: [String], classOrMajor:ClassAndMajorProtocol, didSelectYear: @escaping (String) -> ()){
        
        self.viewcontroller = viewcontroller
        
        genericTableView = GenericTableView(tableview: tableview, items: years, configure: { [weak self] (cell, year) in
            cell.yearLabel.text = year
            cell.selectedBackgroundView? = self!.customSelectionColorView
        })
        
        genericTableView.didSelect = { selectedYear in
            didSelectYear(selectedYear)
        }
        
        alerts = ClassYearAlerts(viewcontroller: viewcontroller, classOrMajor: classOrMajor)
    }
    
    var state:UIState = .ChoosingData{
        willSet(newState){
            update(newState: newState)
        }
    }
    
    private func update(newState: UIState) {
        switch(state, newState) {
        case (.ChoosingData, .Success()):
            alerts.showAddNewClassCompleteAlertWithHandler {
                DispatchQueue.main.async {
                    self.viewcontroller.performSegue(withIdentifier: "ClassYearToClassDetailSegue", sender: self.viewcontroller)
                }
            }
            
            break
        case (.Success(), .Success):
            alerts.showAddNewClassCompleteAlertWithHandler {
                DispatchQueue.main.async {
                    self.viewcontroller.performSegue(withIdentifier: "ClassYearToClassDetailSegue", sender: self.viewcontroller)
                }
            }
            break
        case (.ChoosingData, .Failure(let errorStr)), (.Failure(_),.Failure(let errorStr)):
            if(errorStr == "Permission denied") {
                alerts.showClassAlreadyExistAlert()
            }
            else{
                alerts.showAlert(title: "Lỗi Kết Nối", message: errorStr)
            }
            
            break
      
        case (.Success(), .ChoosingData),(.ChoosingData, .ChoosingData): break
       
        default: fatalError("Not yet implemented \(state) to \(newState)")
        }
    }
}

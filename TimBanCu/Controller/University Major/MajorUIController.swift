//
//  MajorUIController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/30/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class MajorUIController{
    var viewcontroller:MajorViewController!
    var alerts :MajorAlerts!
    var tableview:UITableView!
    private var noResultView:NoResultView!
    private var searchTF:UITextField!
    
    var searchMajors = [MajorDetail]()
    
    var tableViewTool: GenericTableViewTool<MajorDetail, MajorTableViewCell>!
    
    init(viewcontroller:MajorViewController,tableview:UITableView, searchTF:UITextField){
        self.viewcontroller = viewcontroller
        alerts = MajorAlerts(viewcontroller: viewcontroller)
        
        self.tableview = tableview
        self.searchTF = searchTF
        
        setUpTableView()
      ///  noResultView = NoResultView(type: .University)
        
        
        tableViewTool = GenericTableViewTool(tableview: tableview, items: searchMajors) { (cell, major) in
            cell.major = major
        }
        
        tableViewTool.didSelect = { major in
            viewcontroller.selectedMajor = major
            
            viewcontroller.performSegue(withIdentifier: "MajorToClassYearSegue", sender: viewcontroller)
        }
        
        
        /*
        TextFieldDelegateSetter(viewcontroller: viewcontroller, textField: searchTF) { (newString) in
            self.filterVisibleSchools(filter: newString, allMajors: viewcontroller.getAllDataFetched())
        }*/
    }
    
    var state:UIState = .Loading{
        willSet(newState){
            update(newState: newState)
        }
    }
    
    func filterVisibleSchools(filter:String, allMajors:[MajorDetail]){
        searchMajors.removeAll()
        
        if(filter.isEmpty){
            searchMajors = allMajors
            return
        }
        
        for major in allMajors{
            
            if major.majorName.lowercased().range(of:filter.lowercased()) != nil {
                searchMajors.append(major)
            }
        }
        
        reloadTableViewAndUpdateUI()
    }
    
    private func update(newState: UIState) {
        switch(state, newState) {
            
        case (.Loading, .Loading): loadLoadingView()
        case (.Loading, .Success()):
            reloadTableViewAndUpdateUI()
            break
        case (.Loading, .Failure(let errorStr)):
            if(errorStr == "Permission denied") {
                alerts.showMajorAlreadyExistAlert()
            }
            else{
                alerts.showAlert(title: "Không Thể Thêm Khoa", message: errorStr)
            }
            break
            
        default: fatalError("Not yet implemented \(state) to \(newState)")
        }
    }
    
    
    private func loadLoadingView(){
        noResultView.isHidden = true
        tableview.isHidden = false
        //TODO
    }
    
    func showAddNewSchoolAlert(completionHandler: @escaping (_ userInput:String)->Void){
        let handler: (UIAlertAction) -> Void = { _ in
            completionHandler(self.alerts.addNewMajorAlert.getTextFieldInput())
        }
        
        alerts.showAddNewMajorAlert(handler: handler)
    }
    
    
    private func reloadTableViewAndUpdateUI(){
        tableViewTool.items = searchMajors
        tableview.reloadData()
        
        if(tableview.numberOfSections == 0){
            noResultView.isHidden = false
            tableview.isHidden = true
        }
        else{
            noResultView.isHidden = true
            tableview.isHidden = false
        }
    }
    
    private func setUpTableView() {
        tableview.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableview.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
    }
    
    func moveToNextControllerAnimation(){
        viewcontroller.view.endEditing(true)
        
        if (viewcontroller.isMovingFromParentViewController) {
            viewcontroller.navigationController?.hero.isEnabled = true
            viewcontroller.navigationController?.hero.navigationAnimationType = .fade
        }
    }
    
    func showAddNewMajorAlert(completionHandler: @escaping (_ userInput:String)->Void){
        let handler: (UIAlertAction) -> Void = { _ in
            completionHandler(self.alerts.addNewMajorAlert.getTextFieldInput())
        }
        
        alerts.showAddNewMajorAlert(handler: handler)
    }
}

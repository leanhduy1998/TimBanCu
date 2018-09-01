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
    
    init(viewcontroller:MajorViewController,tableview:UITableView, searchTF:UITextField,addNewMajorHandler: @escaping (String)->()){
        self.viewcontroller = viewcontroller
        alerts = MajorAlerts(viewcontroller: viewcontroller) {
            //add new major complete handler
            addNewMajorHandler(self.alerts.addNewMajorAlert.getTextFieldInput())
        }
        
        self.tableview = tableview
        self.searchTF = searchTF
        
        setUpTableView()
        noResultView = NoResultView(type: .University) {
            // add new major handler
            self.showAddNewMajorAlert(completionHandler: addNewMajorHandler)
        }
        
        noResultView.translatesAutoresizingMaskIntoConstraints = false
        noResultView.isHidden = true
        
        viewcontroller.view.addSubview(noResultView)
        viewcontroller.view.bringSubview(toFront: noResultView)
        
        
        //noResultView.centerXAnchor.constraint(equalTo: viewcontroller.view.centerXAnchor).isActive = true
        noResultView.topAnchor.constraint(equalTo: searchTF.topAnchor, constant: 20).isActive = true
        noResultView.leftAnchor.constraint(equalTo: viewcontroller.view.leftAnchor, constant: 20).isActive = true
        noResultView.rightAnchor.constraint(equalTo: viewcontroller.view.rightAnchor, constant: 20).isActive = true
        noResultView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        noResultView.widthAnchor.constraint(equalToConstant: viewcontroller.view.frame.width).isActive = true
        
        
        tableViewTool = GenericTableViewTool(tableview: tableview, items: searchMajors) { (cell, major) in
            cell.major = major
        }
        
        tableViewTool.didSelect = { major in
            viewcontroller.selectedMajor = major
            
            viewcontroller.performSegue(withIdentifier: "MajorToClassYearSegue", sender: viewcontroller)
        }
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
        }
        else{
            for major in allMajors{
                
                if major.majorName.lowercased().range(of:filter.lowercased()) != nil {
                    searchMajors.append(major)
                }
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
            alerts.showAlert(title: "Lỗi Kết Nối", message: errorStr)
            break
        case (.AddingNewData, .Success()):
            alerts.showAddNewMajorCompletedAlert()
            filterVisibleSchools(filter: searchTF.text!, allMajors: searchMajors)
            break
        case (.AddingNewData, .Failure(let errorStr)):
            if(errorStr == "Permission denied") {
                alerts.showMajorAlreadyExistAlert()
            }
            else{
                alerts.showAlert(title: "Không Thể Thêm Khoa", message: errorStr)
            }
            break
        case (.Success(), .AddingNewData): break
        case (.AddingNewData, .AddingNewData): break
            
        default: fatalError("Not yet implemented \(state) to \(newState)")
        }
    }
    
    
    private func loadLoadingView(){
        noResultView.isHidden = true
        tableview.isHidden = false
        //TODO
    }
    
    private func reloadTableViewAndUpdateUI(){
        tableViewTool.items = searchMajors
        tableview.reloadData()
        
        if(searchMajors.count == 0){
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
        state = .AddingNewData
        alerts.showAddNewMajorAlert()
    }
}

//
//  ClassNameUIController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/1/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class ClassNameUIController{
    private var viewcontroller:ClassNameViewController!
    private var alerts: ClassNameAlerts!
    private var noResultView: NoResultView!
    
    private var tableview:UITableView!
    private var searchTF:UITextField!
    private var genericTableView : GenericTableViewTool<ClassDetail, ClassNameTableViewCell>!
    private let customSelectionColorView = CustomSelectionColorView()
    
    var searchClassDetails = [ClassDetail]()
    
    init(viewcontroller:ClassNameViewController,searchTF:UITextField,tableview:UITableView,addNewClassNameHandler: @escaping (String) -> ()){
        self.viewcontroller = viewcontroller
        self.tableview = tableview
        self.searchTF = searchTF
        
        alerts = ClassNameAlerts(viewcontroller: viewcontroller, addNewClassHandler: { (addedClassName) in
            addNewClassNameHandler(addedClassName)
        })
        
        noResultView = NoResultView(viewcontroller: viewcontroller, searchTF: searchTF, type: .Class) {
            self.showAddNewClassNameAlert()
        }
        noResultView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        viewcontroller.view.addSubview(noResultView)
        noResultView.isHidden = true
        
        genericTableView = GenericTableViewTool(tableview: tableview, items: searchClassDetails, configure: { (cell, classDetail) in
            
            cell.classDetailViewModel = ClassNameViewModel(classDetail: classDetail)
            cell.selectedBackgroundView = self.customSelectionColorView
        })
        
        genericTableView.didSelect = { classDetail in
            viewcontroller.selectedClassDetail = classDetail
            viewcontroller.performSegue(withIdentifier: "ClassNameToClassYear", sender: viewcontroller)
        }
    }
    
    var state:UIState = .Loading{
        willSet(newState){
            update(newState: newState)
        }
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
            alerts.showAddNewClassNameComplete()
            filterVisibleClassName(filter: searchTF.text!, allClassDetails: searchClassDetails)
            break
        case (.AddingNewData, .Failure(let errorStr)):
            if(errorStr == "Permission denied") {
                alerts.showClassAlreadyExistAlert()
            }
            else{
                alerts.showAlert(title: "Không Thể Thêm Trường", message: errorStr)
            }
            break
        case (.Success(), .Loading): break
        case (.Success(), .AddingNewData): break
        case (.AddingNewData, .AddingNewData): break
        case (.Success(), .Success()): break
            
        default: fatalError("Not yet implemented \(state) to \(newState)")
        }
    }
    
    func filterVisibleClassName(filter:String, allClassDetails:[ClassDetail]){
        searchClassDetails.removeAll()
        
        if(filter.isEmpty){
            searchClassDetails = allClassDetails
        }
        else{
            for classDetail in allClassDetails{
                
                if classDetail.className.lowercased().range(of:filter.lowercased()) != nil {
                    searchClassDetails.append(classDetail)
                }
            }
        }
        reloadTableViewAndUpdateUI()
    }
    
    private func loadLoadingView(){
        noResultView.isHidden = true
        tableview.isHidden = false
        //TODO
    }
    
    func showAddNewClassNameAlert(){
        state = .AddingNewData
        alerts.showAddNewClassNameAlert()
    }
    
    
    private func reloadTableViewAndUpdateUI(){
        genericTableView.items = searchClassDetails
        tableview.reloadData()
        
        if(searchClassDetails.count == 0){
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
    
}

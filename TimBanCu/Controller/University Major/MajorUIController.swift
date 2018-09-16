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
    private weak var viewcontroller:MajorViewController!
    fileprivate var alerts :MajorAlerts!
    private weak var tableview:UITableView!
    private var noResultView:NoResultView!
    private var searchTF:UITextField!
    
    var searchMajors = [MajorDetail]()
    fileprivate var addNewMajorHandler: (String)->()
    fileprivate var tableViewTool: GenericTableView<MajorDetail, MajorTableViewCell>!
    fileprivate var keyboardHelper:KeyboardHelper!
    
    init(viewcontroller:MajorViewController,tableview:UITableView, searchTF:UITextField,addNewMajorHandler: @escaping (String)->()){
        self.viewcontroller = viewcontroller
        self.tableview = tableview
        self.searchTF = searchTF
        self.addNewMajorHandler = addNewMajorHandler
        
        setupAlerts()
        setupNoResultView()
        setupGenericTableView()
        setupKeyboard()
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
        case (.Loading, .Loading): showLoading()
        case (.Loading, .Success()):
            hideLoading()
            reloadTableViewAndUpdateUI()
            break
        case (.Loading, .Failure(let errorStr)):
            hideLoading()
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
    
    
    private func showLoading(){
        noResultView.isHidden = true
        tableview.isHidden = true
        //TODO
    }
    
    private func hideLoading(){
        // TODO
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
    
    func moveToNextControllerAnimation(){
        viewcontroller.view.endEditing(true)
        
        if (viewcontroller.isMovingFromParentViewController) {
            viewcontroller.navigationController?.hero.isEnabled = true
            viewcontroller.navigationController?.hero.navigationAnimationType = .fade
        }
    }
    
    func showAddNewMajorAlert(){
        state = .AddingNewData
        alerts.showAddNewMajorAlert()
    }
}

// TableView

extension MajorUIController{
    fileprivate func setupGenericTableView(){
        tableViewTool = GenericTableView(tableview: tableview, items: searchMajors) { (cell, major) in
            cell.major = major
        }
        
        tableViewTool.didSelect = { major in
            self.viewcontroller.selectedMajor = major
            
            self.viewcontroller.performSegue(withIdentifier: "MajorToClassYearSegue", sender: self.viewcontroller)
        }
    }
}

// Other UI Setup
extension MajorUIController{
    fileprivate func setupAlerts(){
        alerts = MajorAlerts(viewcontroller: viewcontroller, addNewMajorBtnPressedClosure: addNewMajorHandler)
    }
    fileprivate func setupNoResultView(){
        noResultView = NoResultView(viewcontroller: viewcontroller, searchTF: searchTF, type: .University) {
            self.showAddNewMajorAlert()
        }
        
        noResultView.isHidden = true
        
        viewcontroller.view.addSubview(noResultView)
        viewcontroller.view.bringSubview(toFront: noResultView)
    }
    fileprivate func setupKeyboard(){
        keyboardHelper = KeyboardHelper(viewcontroller: viewcontroller, shiftViewWhenShow: false, keyboardWillShowClosure: nil, keyboardWillHideClosure: nil)
    }
}

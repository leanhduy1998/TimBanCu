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
    fileprivate weak var viewcontroller:ClassNameViewController!
    private var alerts: ClassNameAlerts!
    private var noResultView: NoResultView!
    
    private var tableview:UITableView!
    private var searchTF:UITextField!
    private var genericTableView : GenericTableView<ClassDetail, ClassNameTableViewCell>!
    private let customSelectionColorView = CustomSelectionColorView()
    
    var searchClassDetails = [ClassDetail]()
    
    fileprivate var searchTFUnderline:UnderlineView!
    fileprivate var searchUnderlineHeightAnchor: NSLayoutConstraint?
    fileprivate var addNewClassNameHandler: (String) -> ()
    fileprivate var keyboardHelper:KeyboardHelper!
    
    init(viewcontroller:ClassNameViewController,searchTF:UITextField,tableview:UITableView,addNewClassNameHandler: @escaping (String) -> ()){
        self.viewcontroller = viewcontroller
        self.tableview = tableview
        self.searchTF = searchTF
        self.addNewClassNameHandler = addNewClassNameHandler
        
        setupAlerts()
        setupNoResultView()
        setupGenericTableView()
        setupTextFieldUnderline()
        setupKeyboard()
    }
    
    var state:UIState = .Loading{
        willSet(newState){
            update(newState: newState)
        }
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
        case (.Success(), .Loading): showLoading()
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
    
    private func showLoading(){
        noResultView.isHidden = true
        tableview.isHidden = true
        //TODO
    }
    
    private func hideLoading(){
        // TODO
    }
    
    
}

// Alerts
extension ClassNameUIController{
    fileprivate func setupAlerts(){
        alerts = ClassNameAlerts(viewcontroller: viewcontroller, addNewClassHandler: { (addedClassName) in
            self.addNewClassNameHandler(addedClassName)
        })
    }
    func showAddNewClassNameAlert(){
        state = .AddingNewData
        alerts.showAddNewClassNameAlert()
    }
}

// TextField
extension ClassNameUIController{
    fileprivate func setupTextFieldUnderline(){
        searchTFUnderline = UnderlineView()
        viewcontroller.view.addSubview(searchTFUnderline)
    }
    
    func searchTFDidBeginEditing(allClassDetails:[ClassDetail]){
        filterVisibleClassName(filter: searchTF.text!, allClassDetails: allClassDetails)
        searchTFUnderline.textFieldDidBeginEditing()
    }
    func searchTFDidEndEditing(allClassDetails:[ClassDetail]){
        filterVisibleClassName(filter: searchTF.text!, allClassDetails: allClassDetails)
        searchTFUnderline.textFieldDidEndEditing(searchTF)
    }
}

// TableView
extension ClassNameUIController{
    fileprivate func setupGenericTableView(){
        genericTableView = GenericTableView(tableview: tableview, items: searchClassDetails, configure: { (cell, classDetail) in
            
            cell.classDetailViewModel = ClassNameViewModel(classDetail: classDetail)
            cell.selectedBackgroundView = self.customSelectionColorView
        })
        
        genericTableView.didSelect = { classDetail in
            self.viewcontroller.selectedClassDetail = classDetail
            self.viewcontroller.performSegue(withIdentifier: "ClassNameToClassYear", sender: self.viewcontroller)
        }
    }
    
    fileprivate func reloadTableViewAndUpdateUI(){
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
}

// Other UI setup
extension ClassNameUIController{
    fileprivate func setupNoResultView(){
        noResultView = NoResultView(viewcontroller: viewcontroller, searchTF: searchTF, type: .Class) {
            self.showAddNewClassNameAlert()
        }
        noResultView.translatesAutoresizingMaskIntoConstraints = false
        viewcontroller.view.addSubview(noResultView)
        noResultView.isHidden = true
    }
    fileprivate func setupKeyboard(){
        keyboardHelper = KeyboardHelper(viewcontroller: viewcontroller, shiftViewWhenShow: false, keyboardWillShowClosure: nil, keyboardWillHideClosure: nil)
    }
}

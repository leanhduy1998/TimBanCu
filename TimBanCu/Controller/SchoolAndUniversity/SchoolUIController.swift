//
//  SchoolUIController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/29/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import Lottie

final class SchoolUIController{
    
    fileprivate weak var viewcontroller:SchoolViewController!
    private var schoolType:SchoolType!
    fileprivate weak var tableview:UITableView!
    fileprivate var alerts:SchoolAlerts!
    fileprivate var noResultView:NoResultView!
    private var searchTF:UITextField!
    fileprivate var addNewSchoolClosure: (String)->()
    

    var searchSchoolModels = [School]()
    private var genericTableView: GenericTableView<School, SchoolTableViewCell>!
    
    init(viewcontroller:SchoolViewController, schoolType:SchoolType, tableview:UITableView, searchTF:UITextField, addNewSchoolClosure: @escaping (String)->()){
        self.viewcontroller = viewcontroller
        self.schoolType = schoolType
        self.tableview = tableview
        self.searchTF = searchTF
        self.addNewSchoolClosure = addNewSchoolClosure
        
        setupAlerts()
        setHeroId()
        
        setupNoResultView()
        setupGenericTableView()
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
            reloadTableViewAndUpdateUI()
            break
        case (.Loading, .Failure(let errorStr)):
            alerts.showAlert(title: "Lỗi Kết Nối", message: errorStr)
            break
        case (.AddingNewData, .Success()):
            alerts.showAddNewSchoolCompletedAlert()
            filterVisibleSchools(filter: searchTF.text!, allSchools: searchSchoolModels)
            break
        case (.AddingNewData, .Failure(let errorStr)):
            if(errorStr == "Permission denied") {
                alerts.showSchoolAlreadyExistAlert()
            }
            else{
                alerts.showAlert(title: "Không Thể Thêm Trường", message: errorStr)
            }
            break
        case (.Success(), .Loading): break
        case (.Success(), .AddingNewData): break
        case (.AddingNewData, .AddingNewData): break
            
        default: fatalError("Not yet implemented \(state) to \(newState)")
        }
    }
    
    func filterVisibleSchools(filter:String, allSchools:[School]){
        searchSchoolModels.removeAll()
        
        if(filter.isEmpty){
            searchSchoolModels = allSchools
        }
        else{
            for school in allSchools{
                if school.name.lowercased().range(of:filter.lowercased()) != nil {
                    searchSchoolModels.append(school)
                }
            }
        }
        reloadTableViewAndUpdateUI()
    }
    
    
    
    
    private func showLoading(){
        noResultView.isHidden = true
        tableview.isHidden = false
        //TODO
    }
    
    func showAddNewSchoolAlert(){
        state = .AddingNewData
        alerts.showAddNewSchoolAlert()
    }
    
    
    private func reloadTableViewAndUpdateUI(){
        genericTableView.items = searchSchoolModels
        tableview.reloadData()
        
        if(searchSchoolModels.count == 0){
            noResultView.isHidden = false
            tableview.isHidden = true
        }
        else{
            noResultView.isHidden = true
            tableview.isHidden = false
        }
    }
    
    private func setHeroId(){
        switch(schoolType){
        case .Elementary:
            viewcontroller.view.hero.id = "elementary"
            break
        case .MiddleSchool:
            viewcontroller.view.hero.id = "middleSchool"
            break
        case .HighSchool:
            viewcontroller.view.hero.id = "highSchool"
            break
        case .Elementary:
            viewcontroller.view.hero.id = "elementary"
            break
        default:
            break
        }
    }
    
    func moveToNextControllerAnimation(){
        viewcontroller.view.endEditing(true)
        
        if (viewcontroller.isMovingFromParentViewController) {
            viewcontroller.navigationController?.hero.isEnabled = true
            viewcontroller.navigationController?.hero.navigationAnimationType = .fade
        }
    }
}

// Table View
extension SchoolUIController{
    fileprivate func setupGenericTableView(){
        tableview.isHidden = true
        genericTableView = GenericTableView(tableview: tableview, items: searchSchoolModels) { (cell, school) in
            cell.schoolViewModel = SchoolViewModel(school: school)
        }
        
        genericTableView.didSelect = { school in
            self.viewcontroller.selectedSchool = school
            
            if(self.schoolType == .University){
                self.viewcontroller.performSegue(withIdentifier: "SchoolToMajorSegue", sender: self.viewcontroller)
            }
            else{
                self.viewcontroller.performSegue(withIdentifier: "schoolToClassSegue", sender: self.viewcontroller)
            }
        }
    }
}

// Other UI Setup
extension SchoolUIController{
    fileprivate func setupNoResultView(){
        noResultView = NoResultView(viewcontroller: viewcontroller, searchTF: searchTF, type: .School) {
            self.showAddNewSchoolAlert()
        }
        
        noResultView.translatesAutoresizingMaskIntoConstraints = false
        
        viewcontroller.view.addSubview(noResultView)
        viewcontroller.view.bringSubview(toFront: noResultView)
    }
    fileprivate func setupAlerts(){
        alerts = SchoolAlerts(viewcontroller: viewcontroller, schoolType: schoolType) { (addedSchool) in
            self.addNewSchoolClosure(addedSchool)
        }
    }
}

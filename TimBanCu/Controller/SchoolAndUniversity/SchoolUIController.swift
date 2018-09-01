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
    
    private var viewcontroller:SchoolViewController!
    private var schoolType:SchoolType!
    var tableview:UITableView!
    private var alerts:SchoolAlerts!
    private var noResultView:NoResultView!
    private var searchTF:UITextField!
    

    var searchSchoolModels = [School]()
    
    var tableViewTool: GenericTableViewTool<School, SchoolTableViewCell>!
    
    init(viewcontroller:SchoolViewController, schoolType:SchoolType, tableview:UITableView, searchTF:UITextField, addNewSchoolHandler: @escaping (String)->()){
        self.viewcontroller = viewcontroller
        self.schoolType = schoolType
        self.tableview = tableview
        self.searchTF = searchTF
        
        
        alerts = SchoolAlerts(viewcontroller: viewcontroller, schoolType: schoolType) {
            //add new school complete handler
            addNewSchoolHandler(self.alerts.addNewSchoolAlert.getTextFieldInput())
        }
        
        
        setUpTableView()
        setHeroId()
        
        noResultView = NoResultView(type: .School, addBtnHandler: {
            // add new school handler
            self.showAddNewSchoolAlert(completionHandler: { (newSchool) in
                addNewSchoolHandler(newSchool)
            })
        })
        
        
        noResultView.translatesAutoresizingMaskIntoConstraints = false
        
        viewcontroller.view.addSubview(noResultView)
        viewcontroller.view.bringSubview(toFront: noResultView)
        
        
        //noResultView.centerXAnchor.constraint(equalTo: viewcontroller.view.centerXAnchor).isActive = true
        noResultView.topAnchor.constraint(equalTo: searchTF.topAnchor, constant: 20).isActive = true
        noResultView.leftAnchor.constraint(equalTo: viewcontroller.view.leftAnchor, constant: 20).isActive = true
        noResultView.rightAnchor.constraint(equalTo: viewcontroller.view.rightAnchor, constant: 20).isActive = true
        noResultView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        noResultView.widthAnchor.constraint(equalToConstant: viewcontroller.view.frame.width).isActive = true
    
        
        tableViewTool = GenericTableViewTool(tableview: tableview, items: searchSchoolModels) { (cell, school) in
            cell.schoolViewModel = SchoolViewModel(school: school)
        }
        
        tableViewTool.didSelect = { school in
            viewcontroller.selectedSchool = school
            
            if(self.schoolType == .University){
                viewcontroller.performSegue(withIdentifier: "SchoolToMajorSegue", sender: viewcontroller)
            }
            else{
                viewcontroller.performSegue(withIdentifier: "schoolToClassSegue", sender: viewcontroller)
            }
        }
    }
    
    
    
    
    var state:UIState = .Loading{
        willSet(newState){
            update(newState: newState)
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
    
    
    private func loadLoadingView(){
        noResultView.isHidden = true
        tableview.isHidden = false
        //TODO
    }
    
    func showAddNewSchoolAlert(completionHandler: @escaping (_ userInput:String)->Void){
        state = .AddingNewData
        alerts.showAddNewSchoolAlert()
    }
    
    
    private func reloadTableViewAndUpdateUI(){
        tableViewTool.items = searchSchoolModels
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
    
    private func setUpTableView() {
        tableview.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableview.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
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

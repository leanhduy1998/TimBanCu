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
    private var alertTool:SchoolAlertTool!
    private var noResultView:NoResultView!
    private var searchTF:UITextField!
    

    var searchSchoolModels = [School]()
    
    var tableViewTool: GenericTableViewTool<School, SchoolTableViewCell>!
    
    init(viewcontroller:SchoolViewController, schoolType:SchoolType, tableview:UITableView, searchTF:UITextField){
        self.viewcontroller = viewcontroller
        self.schoolType = schoolType
        self.tableview = tableview
        self.searchTF = searchTF
        alertTool = SchoolAlertTool(viewcontroller: viewcontroller, schoolType: schoolType)
        
        tableview.isHidden = true
        setUpTableView()
        setHeroId()
        
        
        
        noResultView = NoResultView(type: .School)
        
        
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
        
        
        
        let textfieldSetter = TextFieldDelegateSetter(viewcontroller: viewcontroller, textField: searchTF) { (newString) in
            self.filterVisibleSchools(filter: newString, allSchools: viewcontroller.getAllDataFetched())
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
            return
        }
        
        for school in allSchools{
            if school.name.lowercased().range(of:filter.lowercased()) != nil {
                searchSchoolModels.append(school)
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
                alertTool.showSchoolAlreadyExistAlert()
            }
            else{
                alertTool.showAlert(title: "Không Thể Thêm Trường", message: errorStr)
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
            completionHandler(self.alertTool.addNewSchoolAlert.getTextFieldInput())
        }
        
        alertTool.showAddNewSchoolAlert(handler: handler)
    }
    
    
    private func reloadTableViewAndUpdateUI(){
        tableViewTool.items = searchSchoolModels
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

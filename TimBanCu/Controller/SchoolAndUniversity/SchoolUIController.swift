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

class SchoolUIController{
    
    fileprivate weak var viewcontroller:SchoolViewController!
    private var schoolType:EducationLevel!
    fileprivate weak var tableview:UITableView!
    fileprivate var alerts:SchoolAlerts!
    fileprivate var noResultView:NoResultView!
    private var searchTF:UITextField!
    fileprivate var addNewSchoolClosure: (String)->()
    fileprivate var keyboardHelper:KeyboardHelper!
    fileprivate var loadingAnimation:LoadingAnimation!

    var searchSchoolModels = [InstitutionFull]()
    private var genericTableView: GenericTableView<InstitutionFull, SchoolTableViewCell>!
    
    init(viewcontroller:SchoolViewController, schoolType:EducationLevel, tableview:UITableView, searchTF:UITextField, addNewSchoolClosure: @escaping (String)->()){
        self.viewcontroller = viewcontroller
        self.schoolType = schoolType
        self.tableview = tableview
        self.searchTF = searchTF
        self.addNewSchoolClosure = addNewSchoolClosure
        
        setupAlerts()
        setHeroId()
        
        setupNoResultView()
        setupGenericTableView()
        setupKeyboard()
        setupLoadingAnimation()
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
            stopLoadingAnimation()
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
        case (.Success(), .Loading): showLoading()
        case (.Success(), .AddingNewData): break
        case (.AddingNewData, .AddingNewData): break
            
        default: fatalError("Not yet implemented \(state) to \(newState)")
        }
    }
    
    func filterVisibleSchools(filter:String, allSchools:[InstitutionFull]){
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
        switch(schoolType!){
        case .Elementary:
            viewcontroller.view.hero.id = "elementary"
            break
        case .MiddleSchool:
            viewcontroller.view.hero.id = "middleSchool"
            break
        case .HighSchool:
            viewcontroller.view.hero.id = "highSchool"
            break
        case .University:
            viewcontroller.view.hero.id = "university"
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
            self.viewcontroller.selectedInstitution = school
            
            if(self.schoolType == .University){
                self.viewcontroller.performSegue(withIdentifier: "SchoolToMajorSegue", sender: self.viewcontroller)
            }
            else{
                self.viewcontroller.performSegue(withIdentifier: "schoolToClassSegue", sender: self.viewcontroller)
            }
        }
    }
}

// Alerts
extension SchoolUIController{
    fileprivate func setupAlerts(){
        alerts = SchoolAlerts(viewcontroller: viewcontroller, schoolType: schoolType) { [weak self] (addedSchool) in
            self?.addNewSchoolClosure(addedSchool)
        }
    }
    
    func showAddNewSchoolAlert(){
        state = .AddingNewData
        alerts.showAddNewSchoolAlert()
    }
}

// Other UI Setup
extension SchoolUIController{
    fileprivate func setupNoResultView(){
        noResultView = NoResultView(viewcontroller: viewcontroller, searchTF: searchTF, type: .School) { [weak self] in
            self?.showAddNewSchoolAlert()
        }
        
        noResultView.translatesAutoresizingMaskIntoConstraints = false
        
        viewcontroller.view.addSubview(noResultView)
        viewcontroller.view.bringSubview(toFront: noResultView)
    }
    
    fileprivate func setupKeyboard(){
        keyboardHelper = KeyboardHelper(viewcontroller: viewcontroller, shiftViewWhenShow: false, keyboardWillShowClosure: nil, keyboardWillHideClosure: nil)
    }
}

//MARK: Loading Animation
extension SchoolUIController {
    fileprivate func setupLoadingAnimation(){
        loadingAnimation = LoadingAnimation(viewcontroller: viewcontroller)
        loadingAnimation.isHidden = true
    }
    
    func playLoadingAnimation(){
        loadingAnimation.isHidden = false
        loadingAnimation.playAnimation()
    }
    
    func stopLoadingAnimation() {
        loadingAnimation.isHidden = true
        loadingAnimation.stopAnimation()
    }
    
    private func showLoading(){
        noResultView.isHidden = true
        tableview.isHidden = true
        self.playLoadingAnimation()
    }
}

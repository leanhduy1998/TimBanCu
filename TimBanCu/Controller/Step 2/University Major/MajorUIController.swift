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
    var alerts :MajorAlerts!
    private weak var tableview:UITableView!
    private var searchTF:UITextField!
    fileprivate var loadingAnimation:LoadingAnimation!
    
    var searchMajors = [Major]()
    fileprivate var tableViewTool: GenericTableView<Major, MajorTableViewCell>!
    
    init(viewcontroller:MajorViewController,tableview:UITableView, searchTF:UITextField){
        self.viewcontroller = viewcontroller
        self.tableview = tableview
        self.searchTF = searchTF
        
        setupAlerts()
        setupGenericTableView()
        setupLoadingAnimation()
    }
    
    var state:UIState = .Loading{
        willSet(newState){
            update(newState: newState)
        }
    }
    
    func filterVisibleSchools(filter:String, allMajors:[Major]){
        searchMajors.removeAll()
        
        if(filter.isEmpty){
            searchMajors = allMajors
        }
        else{
            for major in allMajors{
                
                if major.name.lowercased().range(of:filter.lowercased()) != nil {
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
            stopLoadingAnimation()
            reloadTableViewAndUpdateUI()
            break
        case (.Loading, .Failure(let errorStr)):
            stopLoadingAnimation()
            alerts.showAlert(title: "Lỗi Kết Nối", message: errorStr)
            break
        case (.Success(), .Success()): break
            
        default: fatalError("Not yet implemented \(state) to \(newState)")
        }
    }
    
    private func reloadTableViewAndUpdateUI(){
        tableViewTool.items = searchMajors
        tableview.reloadData()
        
        if(searchMajors.count == 0){
            viewcontroller.view.bringSubview(toFront: viewcontroller.noResultVC.view)
            viewcontroller.noResultVC.view.isHidden = false
            tableview.isHidden = true
        }
        else{
            viewcontroller.view.sendSubview(toBack: viewcontroller.noResultVC.view)
            viewcontroller.noResultVC.view.isHidden = true
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
}

//MARK: TableView
extension MajorUIController{
    fileprivate func setupGenericTableView(){
        tableViewTool = GenericTableView(tableview: tableview, items: searchMajors) { (cell, major) in
            cell.major = major
        }
        
        tableViewTool.didSelect = { [weak self] major in
            self!.viewcontroller.selectedMajor = major
            
            self!.viewcontroller.performSegue(withIdentifier: "MajorToClassYearSegue", sender: self!.viewcontroller)
        }
    }
}

// MARK: Other UI Setup
extension MajorUIController{
    fileprivate func setupAlerts(){
        alerts = MajorAlerts(viewcontroller: viewcontroller)
    }
}

//MARK: Loading Animation
extension MajorUIController {
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
        viewcontroller.view.sendSubview(toBack: viewcontroller.noResultVC.view)
        viewcontroller.noResultVC.view.isHidden = true
        tableview.isHidden = true
        self.playLoadingAnimation()
    }
    
}

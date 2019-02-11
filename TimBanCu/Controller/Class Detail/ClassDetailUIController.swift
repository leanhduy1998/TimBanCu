//
//  ClassDetailUIController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/4/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class ClassDetailUIController{
    
    private var noResultView:NoResultView!
    private weak var viewcontroller:ClassDetailViewController!
    private var searchTF:UITextField!
    private var genericTableView:GenericTableView<Student, ClassDetailTableViewCell>!
    private var tableview:UITableView!
    private var alerts: ClassDetailAlerts!
    private var addYourselfBtn:UIButton!
    fileprivate var chatBtn:UIButton!
    fileprivate var loadingAnimation:LoadingAnimation!
    
    fileprivate var searchTFUnderline:UnderlineView!
    fileprivate var noResultViewAddBtnClosure: ()->()
    fileprivate var keyboardHelper:KeyboardHelper!
    
    var searchStudents = [Student]()
    
    var state:UIState = .Loading{
        willSet(newState){
            update(newState: newState)
        }
    }
    
    init(viewcontroller:ClassDetailViewController,noResultViewAddBtnClosure: @escaping ()->()){
        self.viewcontroller = viewcontroller
        self.searchTF = viewcontroller.searchTF
        self.addYourselfBtn = viewcontroller.addYourselfBtn
        self.chatBtn = viewcontroller.chatBtn
        self.tableview = viewcontroller.tableview
        self.noResultViewAddBtnClosure = noResultViewAddBtnClosure
        self.searchTFUnderline = UnderlineView(viewcontroller: viewcontroller, searchTF: searchTF)
        
        chatBtn.isHidden = true
        addYourselfBtn.isHidden = true
        
        setupNoResultView()
        setupAlerts()
        setupGenericTableView()
        setupKeyboard()
        setupLoadingAnimation()
    }
    
    private func update(newState: UIState) {
        switch(state, newState) {
        case (.Loading, .Loading): showLoading()
        case (.Loading, .Success()):
            stopLoadingAnimation()
            showAddYourInfoBtnIfYouAreNotInTheClass()
            showNoResultViewIfThereIsNoStudent()
            reloadTableViewAndUpdateUI()
            break
        case (.Loading, .Failure(let errorStr)):
            stopLoadingAnimation()
            alerts.showGeneralErrorAlert(message: errorStr)
            break
        case (.AddingNewData, .Success()):
            alerts.showAddYourInfoCompleteAlert()
            showAddYourInfoBtnIfYouAreNotInTheClass()
            filterVisibleStudent(filter: searchTF.text!, allStudent: searchStudents)
            break
        case (.Success, .Loading):
            showLoading()
            showAddYourInfoBtnIfYouAreNotInTheClass()
            showNoResultViewIfThereIsNoStudent()
            break
        case (.Success(), .Success()):
            reloadTableViewAndUpdateUI()
            showAddYourInfoBtnIfYouAreNotInTheClass()
            break
        case (.Success(), .Failure(let errStr)):
            reloadTableViewAndUpdateUI()
            alerts.showGeneralErrorAlert(message: errStr)
            break
            
        default: fatalError("Not yet implemented \(state) to \(newState)")
        }
    }
    
    func filterVisibleStudent(filter:String, allStudent:[Student]){
        searchStudents.removeAll()
        
        if(filter.isEmpty){
            searchStudents = allStudent
        }
        else{
            for student in allStudent{
                
                if student.fullName.lowercased().range(of:filter.lowercased()) != nil {
                    searchStudents.append(student)
                }
            }
        }
        
        reloadTableViewAndUpdateUI()
    }

    
    private func reloadTableViewAndUpdateUI(){
        genericTableView.items = searchStudents
        tableview.reloadData()
        
        UIView.animate(withDuration: 1) {
            if(self.searchStudents.count == 0){
                self.noResultView.isHidden = false
                self.tableview.isHidden = true
            }
            else{
                self.noResultView.isHidden = true
                self.tableview.isHidden = false
            }
        }
    }
    
    
    // TODO: write unit test for case where if NoResultView is showing, addInfoBtn and chat should be hiding and vice versa
    
    private func showAddYourInfoBtnIfYouAreNotInTheClass(){
        chatBtn.isHidden = false
        addYourselfBtn.isHidden = false
        
        if(searchStudents.count == 0){
            addYourselfBtn.isHidden = true
            chatBtn.isHidden = true
        }
        else if(viewcontroller.youAreInClass()){
            addYourselfBtn.isHidden = true
            chatBtn.isEnabled = true
        }
    }
    
    private func showNoResultViewIfThereIsNoStudent(){
        if(viewcontroller.getAllStudents().count == 0){
            noResultView.isHidden = false
        }
        else{
            noResultView.isHidden = true
        }
    }
}

//Alerts
extension ClassDetailUIController{
    fileprivate func setupAlerts(){
        alerts = ClassDetailAlerts(viewcontroller: viewcontroller)
    }
    func showErrorAlert(errMsg:String){
        alerts.showGeneralErrorAlert(message: errMsg)
    }
}

// TextField
extension ClassDetailUIController{
   /* @objc func textFieldDidChange(_ textField: UITextField) {
        uiController.filterVisibleClassName(filter: textField.text!, allClassDetails: controller.classDetails)
    }*/
    
    func searchTFDidChange(){
        searchTFUnderline.textFieldDidBeginEditing()
    }
    func searchTFDidEndEditing(){
        searchTFUnderline.textFieldDidEndEditing(searchTF)
    }
    
}

//Generic TableView

extension ClassDetailUIController{
    fileprivate func setupGenericTableView(){
        let customSelectionColorView = CustomSelectionColorView()
        
        genericTableView = GenericTableView(tableview: tableview, items: searchStudents, configure: { (cell, student) in
            
            cell.nameLabel.text = student.fullName
            cell.selectedBackgroundView = customSelectionColorView
            
            cell.nameLabel!.hero.isEnabled = true
            cell.imageview!.hero.isEnabled = true
            cell.nameLabel!.hero.id = "\(String(describing: student.fullName))"
            cell.imageview!.hero.id = "\(String(describing: student.fullName))image"
            cell.nameLabel!.hero.modifiers = [.arc]
            cell.imageview!.hero.modifiers = [.arc]
            
            //TODO: unit test for when there is no image
            if(student.images[0].image != nil){
                cell.imageview.image = student.images[0].image
            }
            else{
                // loading
            }
        })
        
        genericTableView.didSelect = { student in
            self.viewcontroller.selectedStudent = student
            self.viewcontroller.performSegue(withIdentifier: "ClassDetailToStudentDetail", sender: self.viewcontroller)
        }
    }
}

// Other UI Setup
extension ClassDetailUIController{
    fileprivate func setupNoResultView(){
        
        noResultView = NoResultView(viewcontroller: viewcontroller, searchTF: searchTF, type: .Student, addBtnPressedClosure: noResultViewAddBtnClosure)
        noResultView.isHidden = true
    }
    
    fileprivate func setupKeyboard(){
        keyboardHelper = KeyboardHelper(viewcontroller: viewcontroller, shiftViewWhenShow: false, keyboardWillShowClosure: nil, keyboardWillHideClosure: nil)
    }
}

//MARK: Loading Animation
extension ClassDetailUIController {
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
        tableview.isHidden = false
        addYourselfBtn.isHidden = true
        self.playLoadingAnimation()
    }
    
}


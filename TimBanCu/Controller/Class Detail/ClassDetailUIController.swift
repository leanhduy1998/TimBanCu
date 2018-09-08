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
    private var viewcontroller:ClassDetailViewController!
    private var searchTF:UITextField!
    private var genericTableView:GenericTableView<Student, ClassDetailTableViewCell>!
    private var tableview:UITableView!
    private var activityIndicator: UIActivityIndicatorView!
    private var alerts: ClassDetailAlerts!
    private var addYourselfBtn:UIButton!
    fileprivate var chatBtn:UIButton!
    
    fileprivate let searchTFUnderline = UnderlineView()
    
    var searchUnderlineHeightAnchor: NSLayoutConstraint?
    
    var searchStudents = [Student]()
    
    var textFieldDidBeginEditing: (()->())?
    var textFieldDidEndEditing: (()->())?
    
    var state:UIState = .Loading{
        willSet(newState){
            update(newState: newState)
        }
    }
    
    init(viewcontroller:ClassDetailViewController,searchTF:UITextField,tableview:UITableView,activityIndicator: UIActivityIndicatorView,addYourselfBtn:UIButton,chatBtn:UIButton){
        self.viewcontroller = viewcontroller
        self.searchTF = searchTF
        self.activityIndicator = activityIndicator
        self.addYourselfBtn = addYourselfBtn
        self.chatBtn = chatBtn
        self.tableview = tableview
        
    
        noResultView = NoResultView(viewcontroller: viewcontroller, searchTF: searchTF, type: .Student, addBtnPressedClosure: {})
        alerts = ClassDetailAlerts(viewcontroller: viewcontroller)
        
        setupGenericTableView()
        setupTextFieldHandlers()
        setupTextFieldUnderline()
        
        setupCloseKeyboardWhenTouchScreenListener()
    }
    
    private func setupCloseKeyboardWhenTouchScreenListener(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        viewcontroller.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        viewcontroller.view.endEditing(true)
    }
    
    
    
    private func update(newState: UIState) {
        switch(state, newState) {
        case (.Loading, .Loading): showLoading()
        case (.Loading, .Success()):
            stopLoading()
            showAddYourInfoBtnIfYouAreNotInTheClass()
            reloadTableViewAndUpdateUI()
            break
        case (.Loading, .Failure(let errorStr)):
            stopLoading()
            alerts.showGeneralErrorAlert(message: errorStr)
            break
        case (.AddingNewData, .Success()):
            alerts.showAddYourInfoCompleteAlert()
            filterVisibleStudent(filter: searchTF.text!, allStudent: searchStudents)
            break
        case (.AddingNewData, .Failure(let errorStr)):
            alerts.showGeneralErrorAlert(message: errorStr)
            break
        case (.Success, .Loading):
            showLoading()
            showAddYourInfoBtnIfYouAreNotInTheClass()
            break
        case (.Success(), .AddingNewData): break
        case (.Success(), .Success()): break
        case (.AddingNewData, .AddingNewData): break
            
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
    
    private func showLoading(){
        noResultView.isHidden = true
        tableview.isHidden = false
        addYourselfBtn.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        //TODO
    }
    private func stopLoading(){
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
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
    
    private func showAddYourInfoBtnIfYouAreNotInTheClass(){
        chatBtn.isEnabled = false
        addYourselfBtn.isHidden = false
        
        if(viewcontroller.youAreInClass()){
            addYourselfBtn.isHidden = true
            chatBtn.isEnabled = true
        }
    }
    
   
}

// TextField
extension ClassDetailUIController{
    fileprivate func setupTextFieldUnderline(){
        viewcontroller.view.addSubview(searchTFUnderline)
        viewcontroller.view.bringSubview(toFront: searchTFUnderline)
        searchTFUnderline.setupConstraints(searchTF: searchTF, viewcontroller: viewcontroller)
        
      //  searchUnderlineHeightAnchor = searchTFUnderline.heightAnchor.constraint(equalToConstant: 1.5)
        searchUnderlineHeightAnchor?.isActive = true
    }
    
    fileprivate func setupTextFieldHandlers(){
        textFieldDidBeginEditing = {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    self.searchTFUnderline.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
                    self.searchUnderlineHeightAnchor?.constant = 2.5
                }, completion: nil)
            }
        }
        
        textFieldDidEndEditing = {
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                if self.searchTF.text == "" {
                    self.searchTFUnderline.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 0.5)
                    self.searchUnderlineHeightAnchor?.constant = 1.5
                }
            }, completion: nil)
        }
    }
}

//Generic TableView

extension ClassDetailUIController{
    fileprivate func setupGenericTableView(){
        let customSelectionColorView = CustomSelectionColorView()
        
        genericTableView = GenericTableView(tableview: tableview, items: searchStudents, configure: { (cell, student) in
            
            cell.nameLabel.text = student.fullName
            cell.selectedBackgroundView = customSelectionColorView
            
            cell.nameLabel!.hero.id = "\(student.fullName)"
            cell.imageview!.hero.id = "\(student.fullName)image"
            cell.nameLabel!.hero.modifiers = [.arc]
            cell.imageview!.hero.modifiers = [.arc]
        })
        
        genericTableView.didSelect = { student in
            self.viewcontroller.selectedStudent = student
            self.viewcontroller.performSegue(withIdentifier: "ClassDetailToStudentDetail", sender: self.viewcontroller)
        }
    }
}

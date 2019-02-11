//
//  SchoolViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/7/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Lottie
import Hero

class SchoolViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    var educationLevel:EducationLevel!
    var selectedInstitution:InstitutionFull!
    
    private var controller:SchoolController!
    private let logicController = SchoolLogicController()
    
    var tableviewAnimation:TableViewAnimation!
    var loadingAnimation:LoadingAnimation!
    var noResultVC:NoResultViewController!
    
    var alerts:SchoolAlerts!
    private var keyboardSetter:KeyboardHelper!
    
    
    func render(newState: UIState) {
        switch(newState) {
            
        case (.Loading): showLoading()
        case (.Success()):
            updateUI()
            break
        case (.Failure(let errorStr)):
            if(errorStr == "Permission denied") {
                alerts.showSchoolAlreadyExistAlert()
            }
            else{
                alerts.showAlert(title: "Không Thể Thêm Trường", message: errorStr)
            }
            break
        default: break
        }
    }

    private func handleAddNewInstitution(state:UIState){
        switch(state){
        case .Success():
            alerts.showAddNewSchoolCompletedAlert()
            render(newState: state)
            break
        default:
            render(newState: state)
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = SchoolController(educationLevel: educationLevel)
        controller.attach(observer: self)
        
        setupSearchTF()
        setupTableView()
        
        view.hero.id = educationLevel.getFullString()
        setupLoadingAnimation()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        moveToNextControllerAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        render(newState: .Loading)
        
        controller.fetchData { [weak self] (uiState) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.render(newState: uiState)
        }
        
        keyboardSetter = KeyboardHelper(viewcontroller: self, shiftViewWhenShow: false, keyboardWillShowClosure: nil, keyboardWillHideClosure: nil)
    }
    
    
    func moveToNextControllerAnimation(){
        view.endEditing(true)
        if (isMovingFromParentViewController) {
            navigationController?.hero.isEnabled = true
            navigationController?.hero.navigationAnimationType = .fade
        }
    }
    
    
    
    private func updateUI(){
        guard let name = searchTF.text else{
            return
        }
        
        let filteredList = logicController.filter(name: name, institutions: controller.institutions)
        
        tableview.reloadData()
        showNoResultVCIfNeeded(list: filteredList)
        stopLoadingAnimation()
    }
    
    private func showNoResultVCIfNeeded(list:[InstitutionFull]){
        if(list.count == 0){
            noResultVC.view.isHidden = false
            view.bringSubview(toFront: noResultVC.view)
            tableview.isHidden = true
        }
        else{
            noResultVC.view.isHidden = true
            view.sendSubview(toBack: noResultVC.view)
            tableview.isHidden = false
        }
    }
    
    private func getFilteredList()->[InstitutionFull]{
        return logicController.filter(name: searchTF.text!, institutions: controller.institutions)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassNumberViewController{
            destination.educationLevel = educationLevel
            destination.school = selectedInstitution
        }
        if let destination = segue.destination as? MajorViewController{
            destination.institution = selectedInstitution
        }
    }
}

// MARK: TableView
extension SchoolViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let school = getFilteredList()[indexPath.row]
        selectedInstitution = school
        
        if(educationLevel == .University){
            performSegue(withIdentifier: "SchoolToMajorSegue", sender: self)
        }
        else{
            performSegue(withIdentifier: "schoolToClassSegue", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableviewAnimation.animateCellFromBelowUpAtLoading(cell: cell, indexPath: indexPath)
    }
}

// MARK: Data updated
extension SchoolViewController:Observer{
    func onDataUpdated() {
        let filteredList = getFilteredList()
        
        let dataSource:TableViewDataSource = .make(for: filteredList, reuseIdentifier: "SchoolTableViewCell", configurer: SchoolTableViewConfigurator())
        tableview.dataSource = dataSource
        tableview.reloadData()
    }
}

// MARK: Setup

extension SchoolViewController{
    func setup(educationLevel:EducationLevel){
        self.educationLevel = educationLevel
        
        self.noResultVC = NoResultVCFactory.getNoResultViewControllerForSchoolViewController(handleAction: {
            
            let result = self.noResultVC.getTextFieldText()
            
            self.controller.addNewInstitution(name: result, completionHandler: { (state) in
                DispatchQueue.main.async {
                    self.handleAddNewInstitution(state: state)
                }
            })
        })
        
        alerts = SchoolAlerts(viewcontroller: self)
    }
    
    fileprivate func setupSearchTF(){
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    fileprivate func setupTableView(){
        tableviewAnimation = TableViewAnimation(tableview: tableview)
        tableview.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableview.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
    }
}

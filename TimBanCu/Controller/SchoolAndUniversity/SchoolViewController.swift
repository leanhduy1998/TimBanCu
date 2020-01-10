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
    
    var alerts:SchoolAlerts!
    
    private var dataSource:TableViewDataSource!
    
    
    
    private var noResultView:NoResultViewController!
    
    private var filteredList = [InstitutionFull]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = SchoolController(educationLevel: educationLevel)
        controller.attach(observer: self)
        
        setupSearchTF()
        setupTableView()
        setupNoResultVC()
        
        view.hero.id = educationLevel.getFullString()
        setupLoadingAnimation()
        
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        moveToNextControllerAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    func setup(){
        render(newState: .Loading)
        
        controller.fetchData { [weak self] (uiState) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.onDataUpdated()
            strongSelf.render(newState: uiState)
        }
    }
    
    
    
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
    
    
    func moveToNextControllerAnimation(){
        view.endEditing(true)
        if (isMovingFromParentViewController) {
            navigationController?.hero.isEnabled = true
            navigationController?.hero.navigationAnimationType = .fade
        }
    }
    
    func updateUI(){
        guard let name = searchTF.text else{
            return
        }
        
        filteredList = logicController.filter(name: name, institutions: controller.institutions)
        updateTableViewData()
        
        showNoResultVCIfNeeded()
        tableview.reloadData()
        stopLoadingAnimation()
    }
    
    private func showNoResultVCIfNeeded(){
        if(filteredList.count == 0){
            noResultView.view.isHidden = false
            view.bringSubview(toFront: noResultView.view)
            noResultView.view.frame = tableview.frame
            tableview.isHidden = true
        }
        else{
            noResultView.view.isHidden = true
            view.sendSubview(toBack: noResultView.view)
            tableview.isHidden = false
        }
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
        
        let school = filteredList[indexPath.row]
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
    
    private func updateTableViewData(){
        let dataSource:TableViewDataSource = .make(for: filteredList, reuseIdentifier: "SchoolTableViewCell", configurer: SchoolTableViewConfigurator())
        self.dataSource = dataSource
        tableview.dataSource = dataSource
        tableview.reloadData()
    }
}

// MARK: Data updated
extension SchoolViewController:Observer{
    func onDataUpdated() {
        updateTableViewData()
    }
}

// MARK: Setup

extension SchoolViewController{
    func inject(educationLevel:EducationLevel){
        self.educationLevel = educationLevel
        
        
        
        alerts = SchoolAlerts(viewcontroller: self)
    }
    
    fileprivate func setupNoResultVC(){
   
        noResultView = NoResultFactory.build(viewcontroller: self)
        noResultView.setOnAcceptBtnPressed(onAccept: { [weak self] (result) in
            
            guard let strongself = self else{
                return
            }
            
            guard let result = result else{
                return
            }
            
            strongself.controller.addNewInstitution(name: result, completionHandler: { (state) in
                DispatchQueue.main.async {
                    if case .Success = state{
                        strongself.alerts.showAddNewSchoolCompletedAlert()
                    }
                    strongself.render(newState: state)
                }
            })
        })
        add(noResultView)
    }
    
    fileprivate func setupSearchTF(){
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    fileprivate func setupTableView(){
        tableviewAnimation = TableViewAnimation(tableview: tableview)
        tableview.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableview.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        onDataUpdated()
    }
}

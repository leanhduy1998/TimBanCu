//
//  UniversityMajorViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/2/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Lottie

class MajorViewController: UIViewController {

    var noResultLabel = NoResultLabel(type: NoResultType.University)
    var noResultAddNewMajorBtn = NoResultButton(type: NoResultType.University)
    
    var school:School!
    
    var majors = [MajorDetail]()
    var searchMajors = [MajorDetail]()
    var selectedMajor:MajorDetail!
    
    let animatedEmoticon = LOTAnimationView(name: "empty_list")
    
    @IBOutlet weak var tableview: UITableView!
    
    var uiController: MajorUIController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiController = MajorUIController(viewcontroller: self)

        setUpAnimatedEmoticon()
        setupNoResultLabelAndButton()
        hideItemsWhileFetchingData()
    }
    
    func fetchData(){
        
    }

    @objc func addNewMajorBtnPressed(_ sender: UIButton?) {
        uiController.showAddNewMajorAlert { (inputedMajorName) in
            if(!(inputedMajorName.isEmpty)){
                let major = MajorDetail(uid: CurrentUserHelper.getUid(), schoolName: self.school.name, majorName: inputedMajorName)
                
                self.selectedMajor = major
                
                self.performSegue(withIdentifier: "MajorToClassYearSegue", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassYearViewController{
            destination.classProtocol = selectedMajor
        }
    }
    
}


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

    var noResultLabel = NoResultLabel(type: Type.University)
    var noResultAddNewMajorBtn = NoResultButton(type: Type.University)
    
    var addNewMajorAlert:UIAlertController!
    var addNewMajorCompletedAlert: UIAlertController!
    var majorAlreadyExistAlert: UIAlertController!
    
    var school:School!
    
    var majors = [MajorDetail]()
    var searchMajors = [MajorDetail]()
    var selectedMajor:MajorDetail!
    
    let animatedEmoticon = LOTAnimationView(name: "empty_list")
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlerts()
        setUpAnimatedEmoticon()
        setupNoResultLabelAndButton()
        hideItemsWhileFetchingData()
    }
    
    func fetchData(){
        
    }

    @objc func addNewMajorBtnPressed(_ sender: UIButton?) {
        self.present(addNewMajorAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassYearViewController{
            destination.classProtocol = selectedMajor
        }
    }
    
}


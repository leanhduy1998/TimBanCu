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

    var noResultAddNewMajorBtn = NoResultButton(title: "Thêm Khoa Mới")
    
    var addNewMajorAlert:UIAlertController!
    var addNewMajorCompletedAlert: UIAlertController!
    var majorAlreadyExistAlert: UIAlertController!
    
    var school:School!
    
    var majors = [MajorDetail]()
    var searchMajors = [MajorDetail]()
    
    var selectedMajor:MajorDetail!
    
    let animatedEmoticon: LOTAnimationView = {
        let animation = LOTAnimationView(name: "empty_list")
        animation.contentMode = .scaleAspectFill
        animation.loopAnimation = true
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlerts()
        setUpAnimatedEmoticon()
        setupNoResultLabelAndButton()
        updateTableviewVisibilityBasedOnSearchResult()
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


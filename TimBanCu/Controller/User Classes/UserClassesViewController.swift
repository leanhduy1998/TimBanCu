//
//  UserClassesViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class UserClassesViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    
    var selectedClassProtocol:ClassProtocol!
    var uiController: UserClassesUIController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        uiController = UserClassesUIController(viewcontroller: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview.reloadData()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassDetailViewController{
            destination.classProtocol = selectedClassProtocol
        }
    }
    

}

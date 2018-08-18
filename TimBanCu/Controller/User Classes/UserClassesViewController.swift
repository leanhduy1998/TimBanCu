//
//  UserClassesViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class UserClassesViewController: UIViewController {
    
    var selectedClassDetail:ClassDetail!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassDetailViewController{
            destination.classDetail = selectedClassDetail
        }
    }
    

}

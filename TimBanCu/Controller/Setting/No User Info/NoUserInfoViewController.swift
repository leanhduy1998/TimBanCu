//
//  NoUserInfoViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/9/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class NoUserInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addStudentInfoBtn(_ sender: Any) {
        let addYourInfoVC = AddYourInfoViewController()
        self.present(addYourInfoVC, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

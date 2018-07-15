//
//  ElementaryViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/9/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class ClassViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var classes: [String]!
    var selectedSchool:School!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassTableViewCell") as? ClassTableViewCell
        cell?.classLabel.text = classes[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ClassToClassDetailSegue", sender: self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassDetailViewController{
            destination.selectedSchool = selectedSchool
        }
    }
    

}

//
//  ClassYearViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/1/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class ClassYearViewController: UIViewController {

    var years = [String]()
    
    @IBOutlet weak var tableview: UITableView!
    var classDetail:ClassDetail!
    
    let customSelectionColorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0, alpha: 0.2)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        tableview.reloadData()
    }
    
    func setupData(){
        for firstTwoDigits in 19...21{
            for lastTwoDigits in 0...99{
                var string = ""
                
                string.append("Năm ")
                string.append("\(firstTwoDigits)")
                if(lastTwoDigits<10){
                    string.append("0")
                }
                string.append("\(lastTwoDigits)")
                
                if(string == "Năm 2019"){
                    return
                }
                
                years.append(string)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassDetailViewController{
            destination.classDetail = classDetail
        }
    }
}

extension ClassYearViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return years.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassYearTableViewCell") as! ClassYearTableViewCell
        cell.yearLabel.text = years[indexPath.row]
        cell.selectedBackgroundView? = customSelectionColorView
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        classDetail.classYear = years[indexPath.row]
        performSegue(withIdentifier: "ClassYearToClassDetailSegue", sender: self)
    }
    
}

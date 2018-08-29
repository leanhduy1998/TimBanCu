//
//  ElementaryViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/9/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class ClassViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    var classes: [String]!
    var school:School!
    var selectedClass:String!
    
    var finishedLoadingInitialTableCells = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    var shownIndexes : [IndexPath] = []
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        cell.transform = CGAffineTransform(translationX: 0, y: tableView.rowHeight / 2)
//        cell.alpha = 0.5
//        
//        UIView.animate(withDuration: 0.5, delay: 1, options: [.curveEaseInOut], animations: {
//            cell.transform = CGAffineTransform(translationX: 0, y: 0)
//            cell.alpha = 1
//        }, completion: nil)
        
//        let lastInitialDisplayableCell = tableview.animateOnlyBeginingCells(tableView: tableView, indexPath: indexPath, model: classes! as [AnyObject], finishLoading: finishedLoadingInitialTableCells)
//
//        if !finishedLoadingInitialTableCells {
//            if lastInitialDisplayableCell {
//                finishedLoadingInitialTableCells = true
//            }
//            tableview.animateCells(cell: cell, tableView: tableview, indexPath: indexPath)
//        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassTableViewCell") as? ClassTableViewCell
        cell?.classLabel.text = classes[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? ClassTableViewCell
        
        selectedClass = cell?.classLabel.text
        
        performSegue(withIdentifier: "ClassToClassDetailSegue", sender: self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassNameViewController{
            destination.school = school
            destination.classNumber = selectedClass
        }
    }
    

}

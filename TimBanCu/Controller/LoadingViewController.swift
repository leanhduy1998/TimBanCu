//
//  LoadingViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/11/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import AWSDynamoDB

class LoadingViewController: UIViewController {
    
    let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
    var schoolViewModels = [SchoolViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 20000
        
        dynamoDBObjectMapper.scan(Schools.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                for item in paginatedOutput.items {
                    let schools = item as? Schools
                    
                    for schoolStr in (schools?._schools)!{
                        let array = schoolStr.components(separatedBy: "&&&")
                        
                        let schoolVM = SchoolViewModel(name: array[0], address: array[1], type: array[2])
                        self.schoolViewModels.append(schoolVM)
                    }
                }
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "LoadingToSelectSchoolTypeSegue", sender: self)
                }
            }
            return nil
        })

    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if let destination = segue.destination as? SelectSchoolTypeViewController{
            destination.schoolViewModels = schoolViewModels
        }*/
        
        let navVC = segue.destination as? UINavigationController
        
        let destination = navVC?.viewControllers.first as! SelectSchoolTypeViewController
        
        destination.schoolViewModels = schoolViewModels
    }
    

}

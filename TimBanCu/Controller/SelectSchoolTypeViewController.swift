//
//  ViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 5/13/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSAuthCore
import AWSMobileClient

import AWSAuthUI

class SelectSchoolTypeViewController: UIViewController {
    
    let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
    var myStrings = [String]()
    
    enum scanType :String{
        case elementary
        case secondary
        case highschool
        case university
    }
    
    var selectedScan:scanType!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            AWSAuthUIViewController
                .presentViewController(with: self.navigationController!,
                                       configuration: nil,
                                       completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                                        if error != nil {
                                            print("Error occurred: \(String(describing: error))")
                                        } else {
                                            // sign in successful.
                                        }
                })
        }
    }
    
    @IBAction func tieuHocBtnPressed(_ sender: Any) {
        selectedScan = .elementary
        performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
    }
    
    @IBAction func trunghoccosoBtnPressed(_ sender: Any) {
        selectedScan = .secondary
        performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
    }
    
    @IBAction func trunghocphothongBtnPressed(_ sender: Any) {
        selectedScan = .highschool
        performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
    }
    
    
    @IBAction func daihocBtnPressed(_ sender: Any) {
        selectedScan = .university
        performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SchoolViewController{
            destination.selectedScanStr = selectedScan.rawValue
        }
    }


}


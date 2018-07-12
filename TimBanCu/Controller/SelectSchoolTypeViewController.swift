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
    
    var schoolViewModels = [SchoolViewModel]()
    var selectedSchools = [SchoolViewModel]()
    
    enum scanType :String{
        case elementary
        case secondary
        case highschool
        case university
    }

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
                                            AWSAuthHelper.sharedInstance.setupCredentialsProvider()
                                        }
                })
        }
        else{
            AWSAuthHelper.sharedInstance.setupCredentialsProvider()
        }
    }
    
    
    
    
    
    @IBAction func tieuHocBtnPressed(_ sender: Any) {
        selectedSchools.removeAll()
        for school in schoolViewModels{
            if(school.type == "elementary"){
                selectedSchools.append(school)
            }
        }
        
        performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
    }
    
    @IBAction func trunghoccosoBtnPressed(_ sender: Any) {
        selectedSchools.removeAll()
        for school in schoolViewModels{
            if(school.type == "secondary"){
                selectedSchools.append(school)
            }
        }
        
        performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
    }
    
    @IBAction func trunghocphothongBtnPressed(_ sender: Any) {
        selectedSchools.removeAll()
        for school in schoolViewModels{
            if(school.type == "highschool"){
                selectedSchools.append(school)
            }
        }
        
        performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
    }
    
    
    @IBAction func daihocBtnPressed(_ sender: Any) {
        selectedSchools.removeAll()
        for school in schoolViewModels{
            if(school.type == "university"){
                selectedSchools.append(school)
            }
        }
        
        performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SchoolViewController{
           destination.schoolViewModels = selectedSchools
        }
    }


}


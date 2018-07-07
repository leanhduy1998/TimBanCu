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

class ViewController: UIViewController {
    
    let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()

    
    var myStrings = [String]()

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
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


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

class ViewController: UIViewController {
    
    let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()

    
    var myStrings = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let credentialsProvider = AWSMobileClient.sharedInstance().getCredentialsProvider()
        
        // Get the identity Id from the AWSIdentityManager
        let identityId = AWSIdentityManager.default().identityId
        
        
        // Do any additional setup after loading the view, typically from a nib.
        if let path = Bundle.main.path(forResource: "thpthanoi", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                
                self.myStrings = myStrings
            
                let count = 0
                recurse(count: count)
                
                
                
                
            } catch {
                print(error)
            }
        }
    }
    
    func recurse(count:Int){
            let name = myStrings[count]
            var address = myStrings[count+1]
            
            if(address.isEmpty){
                address = "?"
            }
            
            let school = School()
            school?._school = name
            school?._address = address
            school?._type = "highschool"
        
            print(name)
            print(address)
            
            dynamoDbObjectMapper.save(school!, completionHandler: {
                (error: Error?) -> Void in
                
                if let error = error {
                    print(school)
                    print("Amazon DynamoDB Save Error: \(error)")
                    return
                }
                print("An item was saved.")
                
                if(count+1 < self.myStrings.count){
                    DispatchQueue.main.async {
                        self.recurse(count: count + 2)
                    }
                    
                }
            })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


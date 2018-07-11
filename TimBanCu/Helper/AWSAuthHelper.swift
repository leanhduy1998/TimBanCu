//
//  AWSAuthHelper.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/10/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import AWSAuthCore

class AWSAuthHelper{
    static var sharedInstance = AWSAuthHelper()
    
    private var credentialsProvider:AWSCognitoCredentialsProvider!
    
    func setupCredentialsProvider(){
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                        identityPoolId:"us-east-1:ba1ea22c-3a89-431d-b63e-e4733cc304f5")
        
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        self.credentialsProvider = credentialsProvider
    }
    
    func getCurrentUID(completionHandler: @escaping (String) -> Void){
        credentialsProvider.getIdentityId().continueWith (block: { (task) -> Any? in
            if let result = task.result {
                completionHandler(result as String)
            }
            else {
                print(task.error?.localizedDescription)
            }
            
            return nil
        })
    }
}

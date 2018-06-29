//
//  ViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 5/13/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let path = Bundle.main.path(forResource: "tieuhoctphcm", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                
               /* for str in myStrings{
                    if(!str.isEmpty){
                        print(str)
                    }
                }*/
                
                var count = 0
                while(count<myStrings.count){
                    
                    
                    count = count + 2
                    
                    if(count<myStrings.count){
                        var name = myStrings[count]
                        
                        count = count + 2
                        
                        if(count<myStrings.count){
                            let address = myStrings[count]
                            //count = count + 6
                            print(name)
                            print(address)
                            
                            while(count<myStrings.count && myStrings[count] != "<tr>"){
                                count = count + 1
                            }
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


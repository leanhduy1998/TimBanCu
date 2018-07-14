//
//  Trash.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/14/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation

class Trash{
    /*
     var di = [String:Any]()
     
     di = temp(t: "tieuhochanoi", di: di, id: signIn.clientID)
     di = temp(t: "tieuhoctphcm", di: di, id: signIn.clientID)
     di = temp(t: "thcshanoi", di: di, id: signIn.clientID)
     di = temp(t: "thcstanbinh", di: di, id: signIn.clientID)
     di = temp(t: "thpthanoi", di: di, id: signIn.clientID)
     di = temp(t: "thpttphcm", di: di, id: signIn.clientID)
     di = temp2(t: "dhcanuoc", di: di, id: signIn.clientID)
     
     self.ref.child("schools").setValue(di)
     
     */
    
    
    func temp(t:String,di:[String:Any],id:String) -> [String:Any]{
        var di = di as? [String:Any]
        
        if let path = Bundle.main.path(forResource: t, ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                
                var name = ""
                var address = ""
                
                var x = 0
                
                while(x+2 < myStrings.count){
                    name = myStrings[x]
                    x=x+1
                    address = myStrings[x]
                    
                    print(name)
                    
                    name = name.replacingOccurrences(of: ".", with: " ", options: .literal, range: nil)
                    name = name.replacingOccurrences(of: "/", with: " ", options: .literal, range: nil)
                    
                    let dic = ["address":address,"type":"elementary","uid":id]
                    
                    di![name] = dic
                    
                    x=x+1
                }
                
            } catch {
                print(error)
            }
        }
        
        return di!
    }
    
    func temp2(t:String,di:[String:Any],id:String) -> [String:Any]{
        var di = di as? [String:Any]
        
        if let path = Bundle.main.path(forResource: t, ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                
                var name = ""
                
                var x = 0
                
                while(x+2 < myStrings.count){
                    name = myStrings[x]
                    
                    name = name.replacingOccurrences(of: ".", with: " ", options: .literal, range: nil)
                    name = name.replacingOccurrences(of: "/", with: " ", options: .literal, range: nil)
                    
                    print(name)
                    
                    let dic = ["address":"?","type":"elementary","uid":id]
                    
                    di![name] = dic
                    
                    x=x+1
                }
                
            } catch {
                print(error)
            }
        }
        
        return di!
    }
}

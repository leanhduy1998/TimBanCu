//
//  FirebaseDownloader.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import UIKit

class FirebaseDownloader{
    static let shared = FirebaseDownloader()
    private let storageRef = Storage.storage().reference()
    private let snapshotDownloader:FirebaseSnapshotDownloader
    private let snapshotParser:FirebaseSnapshotParser
    private let storageDownloader:FirebaseStorageDownloader
    
    init(){
        snapshotDownloader = FirebaseSnapshotDownloader()
        snapshotParser = FirebaseSnapshotParser()
        storageDownloader = FirebaseStorageDownloader()
    }
    
    func getStudent(with uid:String, completionHandler: @escaping (_ student:Student?)->Void){
        snapshotDownloader.getStudent(with: uid) { (publicSS, privateSS, state) in
            
            switch(state){
            case .Success():
                let student = self.snapshotParser.getStudent(uid: uid, publicSS: publicSS!, privateSS: privateSS!)
                completionHandler(student)
            default:
                completionHandler(nil)
            }
        }
    }
    
    func getStudents(classWithYear:ClassWithYear,completionHandler: @escaping ( _ students:[Student], _ error:String?) -> Void){
        
        var error:String?
        
        var students = [Student]()
        
        snapshotDownloader.getStudents(from: classWithYear) {[weak self] (snapshot) in
            
            guard let strongself = self else{
                return
            }
            
            strongself.snapshotParser.getStudentsUids(from: snapshot, completion: { (uids) in
                
                var count = 0
                
                for uid in uids{
                    strongself.snapshotDownloader.getStudent(with: uid, completionHandler: { (publicSS, privateSS, state) in
                        
                        count += 1
                        
                        switch(state){
                        case .Success():
                            let student = strongself.snapshotParser.getStudent(uid: uid, publicSS: publicSS!, privateSS: privateSS!)
                            students.append(student!)
                            
                            
                            break
                        case .Failure(let err):
                            error = err
                            break
                        default:
                            break
                        }
                        
                        if(count == uids.count){
                            completionHandler(students, error)
                        }
                    })
                }
            })
        }
        
    }
    
    private var imageDownloaded = 0
    private var totalImages = 0
    
    func getImages(student:Student, completion:@escaping ()->Void){
        imageDownloaded = 0
        totalImages = student.images.count
        
        for image in student.images{
            if(image.image == nil){
                let imageFromCache = Cache.getImageFromCache(imageName: image.imageName)
                
                if(imageFromCache != nil){
                    image.image = imageFromCache
                    updateImageCounter(completion: completion)
                }
                else{
                    let path = "users/\(student.uid!)/\(image.imageName!)"

                    storageDownloader.getImage(from: path) { (uiimage) in
                        image.image = uiimage
                        self.updateImageCounter(completion: completion)
                    }
                }
            }
            else{
                updateImageCounter(completion: completion)
            }
        }
    }
    
    private func updateImageCounter(completion:()->Void){
        imageDownloaded += 1
        if imageDownloaded == totalImages{
            completion()
        }
    }
    
    func getInstitutions(educationalLevel:EducationLevel, completionHandler:@escaping (_ institutions:[InstitutionFull]?, _ state:UIState)->Void){
        snapshotDownloader.getInstitutions(educationalLevel: educationalLevel) { (state, snapshot) in
            
            switch(state){
            case .Success():
                let institutions = self.snapshotParser.getInstitutions(from: snapshot!, educationLevel: educationalLevel)
                completionHandler(institutions, .Success())
                break
            case .Failure(let err):
                completionHandler(nil, .Failure(err))
                break
            default:
                break
            }
        }
    }
    
    func getClasses(institution: InstitutionFull, classNumber: String,completionHandler: @escaping (UIState, [Class]?) -> ()){
        snapshotDownloader.getClasses(institution: institution, classNumber: classNumber) { [weak self] (state, snapshot) in
            
            guard let strongself = self else{
                return
            }
            
            switch(state){
            case .Success():
                let models = strongself.snapshotParser.getClasses(from: snapshot!, institution: institution, classNumber: classNumber)
                completionHandler(.Success(),models)
                break
            case .Failure(let err):
                completionHandler(.Failure(err),nil)
                break
            default:
                break
            }
        }
    }
}

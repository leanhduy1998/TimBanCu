//
//  Student.swift
//  MySampleApp
//
//
// Copyright 2018 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.21
//

import Foundation
import UIKit
import AWSDynamoDB

@objcMembers
class Student: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _name: String?
    var _birthday: String?
    var _class: String?
    var _email: String?
    var _images: [String: String]?
    var _phone: String?
    var _school: String?
    var _uid: String?
    
    class func dynamoDBTableName() -> String {

        return "timbancu-mobilehub-603959887-Student"
    }
    
    class func hashKeyAttribute() -> String {

        return "_name"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
               "_name" : "name",
               "_birthday" : "birthday",
               "_class" : "class",
               "_email" : "email",
               "_images" : "images",
               "_phone" : "phone",
               "_school" : "school",
               "_uid" : "uid",
        ]
    }
}

//
//  userModel.swift
//  ELearningProjectAbderrahmen&hazem
//
//  Created by Mac-Mini-2021 on 28/11/2021.
//

import Foundation

struct User: Encodable {
    
    var _id: String
    var name: String
    var email: String
    var role: String
    var password: String
    var date: String
    var niveau: Int
    var langue: String
    var avatar: String
    var token : String
    var userID :String
    var vie: Int
    var progress: [Int]
    var scores: [Int]
    var stars: [Int]
    
}



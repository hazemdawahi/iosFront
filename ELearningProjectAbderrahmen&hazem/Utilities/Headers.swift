//
//  Headers.swift
//  ELearningProjectAbderrahmen&hazem
//
//  Created by Apple Mac on 20/12/2021.
//

import Foundation
import Alamofire

class Headers {
    
    static func makeHeaders() -> HTTPHeaders {
        HTTPHeaders([
         HTTPHeader(name: "JWT", value: UserDefaults.standard.string(forKey: "token")!),
         HTTPHeader(name: "UserID", value: UserDefaults.standard.string(forKey: "userID")!),
         HTTPHeader(name: "Role", value: UserDefaults.standard.string(forKey: "role")!),
         HTTPHeader(name: "langue", value: UserDefaults.standard.string(forKey: "langue")!)
        ])
    }

}

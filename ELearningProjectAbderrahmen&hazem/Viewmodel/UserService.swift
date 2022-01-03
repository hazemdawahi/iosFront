//
//  userService.swift
//  ELearningProjectAbderrahmen&hazem
//
//  Created by Mac-Mini-2021 on 28/11/2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserService{
    
    static let shareinstance = UserService()
    
    func login(email: String, motdepass: String, completed: @escaping (Bool)->()){
        let headers: HTTPHeaders = [.contentType("application/json")]
        AF.request("http://localhost:8885/api/login",
                   method: .post,
                   parameters: ["email":email, "password":motdepass],
                   encoder: JSONParameterEncoder.default,
                   headers: headers )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response{ response in
                switch response.result{
                case .success:
                    
                    if response.response?.statusCode == 200{
                        
                        
                        var user = self.makeUser(jsonItem: JSON(response.data!)["user"])
                        print(user)
                        
                        if user.progress.count < 8 {
                            user.progress = [0,0,0,0,0,0,0,0]
                        }
                        
                        if user.scores.count < 8 {
                            user.scores = [0,0,0,0,0,0,0,0]
                        }
                        
                        if user.stars.count < 8 {
                            user.stars = [0,0,0,0,0,0,0,0]
                        }
                        
                        print(user)
                        
                        UserDefaults.standard.set(user._id, forKey: "userID")
                        UserDefaults.standard.set(user.token, forKey: "token")
                        UserDefaults.standard.set(user.name, forKey: "name")
                        UserDefaults.standard.set(user.email, forKey: "email")
                        UserDefaults.standard.set(user.role, forKey: "role")
                        UserDefaults.standard.set(user.password, forKey: "password")
                        UserDefaults.standard.set(user.date, forKey: "date")
                        UserDefaults.standard.set(user.langue, forKey: "langue")
                        UserDefaults.standard.set(user.avatar, forKey: "avatar")
                        
                        UserDefaults.standard.set(user.vie, forKey: "vie")
                        UserDefaults.standard.set(user.niveau, forKey: "niveau")
                        UserDefaults.standard.set(user.scores, forKey: "scores")
                        UserDefaults.standard.set(user.progress, forKey: "progress")
                        UserDefaults.standard.set(user.stars, forKey: "stars")
                        
                        completed(true)
                    }else{
                        completed(false)
                    }
                case let .failure(error):
                    debugPrint(error)
                    completed(false)
                }
            }
    }
    func googlelogin(email: String,name:String,password:String, completed: @escaping (Bool)->()){
        let headers: HTTPHeaders = [.contentType("application/json")]
        AF.request("http://localhost:8885/api/glog",
                   method: .post,
                   parameters: ["email":email,"name":name,"password":password],
                   encoder: JSONParameterEncoder.default,
                   headers: headers )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response{ response in
                switch response.result{
                case .success:
                    
                    if response.response?.statusCode == 200{
                        
                        
                        var user = self.makeUser(jsonItem: JSON(response.data!)["user"])
                        print(user)
                        
                        if user.progress.count < 8 {
                            user.progress = [0,0,0,0,0,0,0,0]
                        }
                        
                        if user.scores.count < 8 {
                            user.scores = [0,0,0,0,0,0,0,0]
                        }
                        
                        if user.stars.count < 8 {
                            user.stars = [0,0,0,0,0,0,0,0]
                        }
                        
                        print(user)
                        
                        UserDefaults.standard.set(user._id, forKey: "userID")
                        UserDefaults.standard.set(user.token, forKey: "token")
                        UserDefaults.standard.set(user.name, forKey: "name")
                        UserDefaults.standard.set(user.email, forKey: "email")
                        UserDefaults.standard.set(user.role, forKey: "role")
                        UserDefaults.standard.set(user.password, forKey: "password")
                        UserDefaults.standard.set(user.date, forKey: "date")
                        UserDefaults.standard.set(user.langue, forKey: "langue")
                        UserDefaults.standard.set(user.avatar, forKey: "avatar")
                        
                        UserDefaults.standard.set(user.vie, forKey: "vie")
                        UserDefaults.standard.set(user.niveau, forKey: "niveau")
                        UserDefaults.standard.set(user.scores, forKey: "scores")
                        UserDefaults.standard.set(user.progress, forKey: "progress")
                        UserDefaults.standard.set(user.stars, forKey: "stars")
                        
                        completed(true)
                    }else{
                        completed(false)
                    }
                case let .failure(error):
                    debugPrint(error)
                    completed(false)
                }
            }
    }

    func register(user : User, completionHandler:@escaping (Bool)->()){
        let headers: HTTPHeaders = [.contentType("application/json")]
        AF.request("http://localhost:8885/api/register",
                   method: .post,
                   parameters: user,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response{ response in
                debugPrint(response)
                switch response.result {
                case .success(let data):
                    do {
                        let json  = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(json)
                        if response.response?.statusCode == 200{
                            completionHandler(true)
                        }else{
                            completionHandler(false)
                        }
                    } catch  {
                        print(error.localizedDescription)
                        completionHandler(false)
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
    }
    
    func motDePasseOublie(email: String, codeDeReinit: String, completed: @escaping (Bool) -> Void) {
        AF.request("http://localhost:8885/api/user/motDePasseOublie",
                   method: .post,
                   parameters: ["email": email, "codeDeReinit": codeDeReinit])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func changerMotDePasse(email: String, nouveauMotDePasse: String, completed: @escaping (Bool) -> Void) {
        AF.request("http://localhost:8885/api/user/changerMotDePasse",
                   method: .put,
                   parameters: ["email": email,"nouveauMotDePasse": nouveauMotDePasse])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func logout(completed: @escaping (Bool)->() ) {
        AF.request("http://localhost:8885/api/logout",
                   method: .get,
                   headers: Headers.makeHeaders())
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                
                let jsonData = JSON(response.data!)
                debugPrint(jsonData)
                
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    debugPrint(error)
                    completed(false)
                }
            }
    }
    
    func changeAvatar(uiImage: UIImage, completed: @escaping (Bool) -> Void ) {
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(uiImage.jpegData(compressionQuality: 0.5)!, withName: "image" , fileName: "image.jpeg", mimeType: "image/jpeg")
            
        },to: "http://localhost:8885/api/user/change-avatar",
                  method: .post,
                  headers: Headers.makeHeaders())
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Success")
                    completed(true)
                case let .failure(error):
                    completed(false)
                    print(error)
                }
            }
    }
    
    func getUser(completed: @escaping (Bool,User?)->() ){
        AF.request("http://localhost:8885/api/user",
                   method: .get,
                   headers: Headers.makeHeaders())
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response{ response in
                switch response.result {
                case .success:
                    
                    var user = self.makeUser(jsonItem: JSON(response.data!)["user"])
                    
                    if user.progress.count < 8 {
                        user.progress = [0,0,0,0,0,0,0,0]
                    }
                    
                    UserDefaults.standard.set(user.vie, forKey: "vie")
                    UserDefaults.standard.set(user.niveau, forKey: "niveau")
                    UserDefaults.standard.set(user.scores, forKey: "scores")
                    UserDefaults.standard.set(user.progress, forKey: "progress")
                    UserDefaults.standard.set(user.stars, forKey: "stars")
                    
                    completed(true, user)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
                
            }
    }
    
    func updateProfile(name: String, email: String, password: String ,completed: @escaping (Bool)->() ){
        AF.request("http://localhost:8885/api/user/profile",
                   method: .put,
                   parameters: [
                    "name": name,
                    "email": email,
                    "password": password
                   ],
                   encoding: JSONEncoding.default,
                   headers: Headers.makeHeaders())
            .validate(statusCode: 200..<399)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                   
                case .success:
                    if (response.response?.statusCode == 200) {
                        completed(true)
                    } else {
                        completed(false)
                    }
              
                case let .failure(error):
                    print(response.response?.statusCode)
                    debugPrint(error)
              
                    if (response.response?.statusCode == 200) {
                        completed(true)
                    } else {
                        completed(false)
                    }
                }
            }
    }
    
    func updateStats(isLevelingUp: Bool, resetProgress: Bool, score: Int, starsGained: Int, forLevel: Int, vieAddition: Int, completed: @escaping (Bool, User?)->() ){
        var level = Int(UserDefaults.standard.string(forKey: "niveau")!)!
        var vie = Int(UserDefaults.standard.string(forKey: "vie")!)!
        var scores = UserDefaults.standard.array(forKey: "scores") as! [Int]
        var stars = UserDefaults.standard.array(forKey: "stars") as! [Int]
        var progress = UserDefaults.standard.array(forKey: "progress") as! [Int]
        
        if (resetProgress) {
            progress[forLevel - 1] = 0
            scores[forLevel - 1] = 0
            stars[forLevel - 1] = starsGained
        } else {
            progress[forLevel - 1] += 1
            scores[forLevel - 1] += score
            vie += vieAddition
        }
        
        if isLevelingUp{
            level += 1
        }
        
        AF.request("http://localhost:8885/api/user/stats",
                   method: .put,
                   parameters: [
                    "niveau" : String(level),
                    "vie": String(vie),
                    "scores": scores,
                    "progress": progress,
                    "stars": stars
                   ],
                   encoding: JSONEncoding.default,
                   headers: Headers.makeHeaders())
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                
                let jsonData = JSON(response.data!)
                debugPrint(jsonData)
                
                switch response.result {
                case .success:
                    
                    var user = self.makeUser(jsonItem: JSON(response.data!)["user"])
                    
                    if user.progress.count < 8 {
                        user.progress = [0,0,0,0,0,0,0,0]
                    }
                    
                    UserDefaults.standard.set(user.vie, forKey: "vie")
                    UserDefaults.standard.set(user.niveau, forKey: "niveau")
                    UserDefaults.standard.set(user.scores, forKey: "scores")
                    UserDefaults.standard.set(user.progress, forKey: "progress")
                    UserDefaults.standard.set(user.stars, forKey: "stars")
                    
                    print("VIE ----------------------------------------------")
                    print(user.vie)
                    print("SCORE --------------------------------------------")
                    print(user.scores)
                    print("PROGRES ------------------------------------------")
                    print(user.progress)
                    print("STARS --------------------------------------------")
                    print(user.stars)
                    print("NIVEAU -------------------------------------------")
                    print(user.niveau)
                    print("--------------------------------------------------")
                    
                    completed(true, user)
                    
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func switchUserSession(langue: String, completed: @escaping (Bool, User?)->() ){
        AF.request("http://localhost:8885/api/user/switchUserSession",
                   method: .put,
                   parameters: [
                    "langue": langue
                   ],
                   encoding: JSONEncoding.default,
                   headers: Headers.makeHeaders())
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                
                let jsonData = JSON(response.data!)
                debugPrint(jsonData)
                
                switch response.result {
                case .success:
                    
                    var user = self.makeUser(jsonItem: JSON(response.data!)["user"])
                    
                    if user.progress.count < 8 {
                        user.progress = [0,0,0,0,0,0,0,0]
                    }
                    
                    UserDefaults.standard.set(user.vie, forKey: "vie")
                    UserDefaults.standard.set(user.niveau, forKey: "niveau")
                    UserDefaults.standard.set(user.scores, forKey: "scores")
                    UserDefaults.standard.set(user.progress, forKey: "progress")
                    UserDefaults.standard.set(user.stars, forKey: "stars")
                    
                    print("CHANGEMENT DE LANGUAGE ***************************")
                    print(user.langue)
                    print("VIE ----------------------------------------------")
                    print(user.vie)
                    print("SCORE --------------------------------------------")
                    print(user.scores)
                    print("PROGRES ------------------------------------------")
                    print(user.progress)
                    print("STARS --------------------------------------------")
                    print(user.stars)
                    print("NIVEAU -------------------------------------------")
                    print(user.niveau)
                    print("**************************************************")
                    
                    completed(true, user)
                    
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func makeUser(jsonItem: JSON) -> User {
        return User(
            _id: jsonItem["_id"].stringValue,
            name: jsonItem["name"].stringValue,
            email: jsonItem["email"].stringValue,
            role: jsonItem["role"].stringValue,
            password: jsonItem["password"].stringValue,
            date: jsonItem["date"].stringValue,
            niveau: jsonItem["niveau"].intValue,
            langue: jsonItem["langue"].stringValue,
            avatar: jsonItem["avatar"].stringValue,
            token: jsonItem["token"].stringValue,
            userID: jsonItem["_id"].stringValue,
            vie: jsonItem["vie"].intValue,
            progress: jsonArrayToArray(jsonArray: jsonItem["progress"].arrayValue),
            scores: jsonArrayToArray(jsonArray: jsonItem["scores"].arrayValue),
            stars: jsonArrayToArray(jsonArray: jsonItem["stars"].arrayValue)
        )
    }
    
    func jsonArrayToArray(jsonArray: [JSON]) -> [Int] {
        var items : [Int] = []
        for jsonItem in jsonArray {
            items.append(jsonItem.intValue)
        }
        return items
    }
}

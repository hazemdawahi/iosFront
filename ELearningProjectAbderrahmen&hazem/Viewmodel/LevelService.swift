//
//  LevelService.swift
//  ELearningProjectAbderrahmen&hazem
//
//  Created by Mac-Mini-2021 on 29/11/2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class LevelService {
    
    static let shareinstance = LevelService()
    
    func getAll(completed: @escaping (Bool, [Level]?) -> Void ) {
        AF.request("http://localhost:8885/api/level/getAll",
                   method: .get//,
                  // encoding: JSONEncoding.default//,
                  // headers: Headers.makeHeaders()
        )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    
                    var levels : [Level]? = []
                    for singleJsonItem in JSON(response.data!)["levels"] {
                        levels!.append(self.makeLevel(jsonItem: singleJsonItem.1))
                    }
                    
                    completed(true, levels)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func getLevel(level: Int, completed: @escaping (Bool, Level?) -> Void ) {
        
        AF.request("http://localhost:8885/api/level",
                   method: .post,
                   parameters: ["level": String(level)],
                   encoding: JSONEncoding.default,
                   headers: Headers.makeHeaders())
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true, self.makeLevel(jsonItem: JSON(response.data!)["level"]))
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func checkPass(answer: String, userAnswer: String, completed: @escaping (Bool, Bool?) -> Void ) {
        AF.request("http://localhost:8885/api/level/check-pass",
                   method: .post,
                   parameters: [
                    "answer": answer,
                    "userAnswer": userAnswer
                   ],
                   headers: Headers.makeHeaders())
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    debugPrint(jsonData)
                    completed(true, jsonData["isCorrect"].boolValue)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func makeLevel(jsonItem: JSON) -> Level {
        Level(
            level: jsonItem["level"].intValue,
            questions: jsonArrayToArray(jsonArray: jsonItem["questions"].arrayValue),
            answers: jsonArrayToArray(jsonArray: jsonItem["answers"].arrayValue)
        )
    }
    
    func jsonArrayToArray(jsonArray: [JSON]) -> [String] {
        var items : [String] = []
        for jsonItem in jsonArray {
            items.append(jsonItem.stringValue)
        }
        return items
    }
}

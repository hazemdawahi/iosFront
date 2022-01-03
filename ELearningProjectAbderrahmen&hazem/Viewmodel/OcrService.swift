import Foundation

import Alamofire
import UIKit
import SwiftyJSON

class ocrService {
    func addPublication(publication: String, uiImage: UIImage, completed: @escaping (Bool, String?) -> Void ) {
        
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(uiImage.pngData()!, withName: "image" , fileName: "image.png", mimeType: "image/png")
                
                for (key, value) in
                        [
                            "langue": publication
                            //"date": publication.date!,
                            //"utilisateur": UserDefaults.standard.string(forKey: "userId")!
                        ]
                {
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }
                
            },to: "http://localhost:8885/api/feature",
                      method: .post)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseData { response in
                    switch response.result {
                    case .success:
                        print("Success")
                        let jsonData = JSON(response.data!)
                        
                        completed(true, jsonData["newStr"].stringValue )
                    case let .failure(error):
                        completed(false,nil)
                        print(error)
                    }
                }
        }

}

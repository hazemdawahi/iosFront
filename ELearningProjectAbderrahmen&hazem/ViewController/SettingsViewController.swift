//
//  SettingsViewController.swift
//  ELearningProjectAbderrahmen&hazem
//
//  Created by Apple Mac on 20/12/2021.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController{
    
    @IBOutlet weak var qrImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let url = "http://localhost:8885/api/user/showForQr/" + UserDefaults.standard.string(forKey: "userID")!
        
        let data = url.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                qrImage.image =  UIImage(ciImage: output)
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        
        UserDefaults.standard.set("", forKey: "userID")
        UserDefaults.standard.set("", forKey: "token")
        UserDefaults.standard.set("", forKey: "name")
        UserDefaults.standard.set("", forKey: "email")
        UserDefaults.standard.set("", forKey: "role")
        UserDefaults.standard.set("", forKey: "password")
        UserDefaults.standard.set("", forKey: "date")
        UserDefaults.standard.set("", forKey: "niveau")
        UserDefaults.standard.set("", forKey: "langue")
        
        UserService.shareinstance.logout { success in
            if success {
                self.performSegue(withIdentifier: "logoutSegue", sender: nil)
            } else {
                self.present(Alert.makeServerErrorAlert(),animated: true)
            }
        }
    }
}

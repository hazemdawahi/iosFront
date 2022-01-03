//
//  SignupViewController.swift
//  
//
//  Created by Mac-Mini-2021 on 21/11/2021.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var connecter: UIButton!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var niveau: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var langue: UITextField!
    @IBOutlet weak var confirmpassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func connectionAction(_ sender: Any) {
        guard let name = self.nameLabel.text else{return}
        guard let niveau = self.niveau.text else{return}
        guard let email = self.mail.text else{return}
        guard let password = self.password.text else{return}
        guard let langue = self.langue.text else{return}
        
        if (Int(niveau) == nil) {
            self.present(Alert.makeAlert(titre: "Error", message: "level should be int"), animated: true)
            return
        }
        
        if (!(self.confirmpassword.text! == self.password.text!)){
            self.present(Alert.makeAlert(titre: "Error", message: "Passwords don't match, please verify and try again"), animated: true)
            return
        }
        
        UserService.shareinstance.register(user: User(_id: "", name: name, email: email, role: "", password: password, date: "", niveau: Int(niveau)!, langue: langue, avatar: "", token: "", userID: "", vie: 1, progress: [0,0,0,0,0,0,0,0,0], scores: [0,0,0,0,0,0,0,0,0], stars: [0,0,0,0,0,0,0,0,0])){
            (isSuccess) in
            if isSuccess{
                self.present(Alert.makeAlert(titre: "Alert", message: "User register successfully"), animated: true)
            } else {
                self.present(Alert.makeAlert(titre: "Alert", message: "Please try again "), animated: true)
            }
        }
    }
}


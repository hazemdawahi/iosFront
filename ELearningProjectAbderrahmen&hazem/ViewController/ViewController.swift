//
//  ViewController.swift
//  ELearningProjectAbderrahmen&hazem
//
//  Created by Mac2021 on 6/11/2021.
//

import UIKit
import Alamofire
import CoreData
import GoogleSignIn
import LocalAuthentication


//import LocalAuthentication


//import Parse

class ViewController: UIViewController{
    
    let signInConfig = GIDConfiguration.init(clientID:"73453057160-hlt2jkm1chiq7bo35t1h73fdbbgmts4n.apps.googleusercontent.com")


    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var googleLoginStackView: UIStackView!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var mdp: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UserService.shareinstance.viedate()
        /*
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        let gSignIn = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: googleLoginStackView.frame.width, height: googleLoginStackView.frame.height))
        googleLoginStackView.addSubview(gSignIn)
        */
    }
    
    @IBAction func logoutGoogle(_ sender: Any) {
        //print ("signOut")
        //GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
           guard error == nil else { return }
            let emailAddress = user?.profile?.email
            let givenName = user?.profile?.givenName
            UserService.shareinstance.googlelogin(email: emailAddress!,name:givenName!, password: "00000000"){
                (isSuccess) in
                if isSuccess{
                    self.performSegue(withIdentifier: "levels", sender: nil)
                    //self.present(Alert.makeAlert(titre: "Alert", message: "User register successfully"), animated: true)
                    self.present(Alert.makeAlert(titre: "Alert", message: " successfully"), animated: true)
                } else {
                    self.present(Alert.makeAlert(titre: "Alert", message: "Please try again "), animated: true)
                }
            }

        }

    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        guard let username = self.email.text else{return}
        guard let password = self.mdp.text else{return}
        //let admin = adminModel(email: email, motdepasse: motdepasse)
        if(self.email.text!.isEmpty || self.mdp.text!.isEmpty){
            self.present(Alert.makeAlert(titre: "Avertissement", message: "Vous devez taper vos identifiants"), animated: true)
            return
        }
        
        UserService.shareinstance.login(email: username, motdepass: password){
            (isSuccess) in
            if isSuccess{
                self.performSegue(withIdentifier: "levels", sender: nil)
                //self.present(Alert.makeAlert(titre: "Alert", message: "User register successfully"), animated: true)
                self.present(Alert.makeAlert(titre: "Alert", message: " successfully"), animated: true)
            } else {
                self.present(Alert.makeAlert(titre: "Alert", message: "Please try again successfully"), animated: true)
            }
        }
        
        
    }
    
    func testSegue(_ identifier: String!, sender:AnyObject!){
        performSegue(withIdentifier: identifier, sender: sender)
    }
    func propmt(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive , handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func forgotPasswordBtn(_ sender: Any) {
    }
    
    
    
}

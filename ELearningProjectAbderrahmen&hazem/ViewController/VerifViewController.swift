//
//  blankViewController.swift
//  ELearningProjectAbderrahmen&hazem
//
//  Created by Mac-Mini-2021 on 10/12/2021.
//

import UIKit


class VerifViewController: UIViewController {
    
    let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if reachability.connection == .unavailable {
            self.present(Alert.makeAlert(titre: "Warning", message: "Internet connection is required !"),animated: true)
        } else {
            checkUser()
        }
    }
    
    func checkUser(){
        if UserDefaults.standard.string(forKey: "token") != nil {
            let token = UserDefaults.standard.string(forKey: "token")!
            print(token)
            if (!(token=="")) {
                performSegue(withIdentifier: "levelsegu", sender:nil )
                
            } else {
                performSegue(withIdentifier: "loginsegu", sender:nil )
            }
        } else {
            performSegue(withIdentifier: "loginsegu", sender:nil )
        }
    }
}

//
//  LanguageViewController.swift
//  ELearningProjectAbderrahmen&hazem
//
//  Created by Apple Mac on 20/12/2021.
//

import Foundation
import UIKit

class LanguageViewController: UIViewController{
    
    let languages = ["fr","it","de"]
    var currentLanguageIndex = 0
    
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var lagnuageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UserService.shareinstance.getUser { [self] success, user in
            
            switch user?.langue {
            case "fr":
                currentLanguageIndex = 0
                break
            case "it":
                currentLanguageIndex = 1
                break
            case "de":
                currentLanguageIndex = 2
                break
            default:
                break
            }
            
            setupViews()
        }
    }
    
    func setupViews() {
        print(currentLanguageIndex)
        let language = languages[currentLanguageIndex]
        
        flagImage.image = UIImage(named: "flag_" + language)
        
        switch language {
        case "fr":
            lagnuageLabel.text = "Français"
            break
        case "de":
            lagnuageLabel.text = "Deutsch"
            break
        case "it":
            lagnuageLabel.text = "Italiano"
            break
        default:
            break
        }
    }
    
    @IBAction func languageSwitchLeft(_ sender: Any) {
        currentLanguageIndex -= 1
        
        if currentLanguageIndex < 0 {
            currentLanguageIndex = languages.count - 1
        }
        
        setupViews()
    }
    
    @IBAction func languageSwitchRight(_ sender: Any) {
        currentLanguageIndex += 1
        
        if currentLanguageIndex > languages.count - 1  {
            currentLanguageIndex = 0
        }
        
        setupViews()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
        UserService.shareinstance.switchUserSession(langue: languages[currentLanguageIndex]) { success, user in
            if success {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.present(Alert.makeServerErrorAlert(),animated: true)
            }
        }
    }
}

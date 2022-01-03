//
//  EvaluationViewController.swift
//  ELearningProjectAbderrahmen&hazem
//
//  Created by Mac-Mini-2021 on 29/11/2021.
//

import UIKit
import AVFoundation

class EvaluationViewController: UIViewController {
    
    var activeLevel: Level?
    var activeQuestion: String?
    var activeAnswer: String?
    var activeScore: Int = 0
    
    var currentUserLevel: Int?
    
    var currentLevelIndex: Int?
    var currentQuestionIndex: Int = 0
    
    @IBOutlet weak var levelImage: UIImageView!
    @IBOutlet weak var levelProgress: UIProgressView!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTF: UITextField!
    @IBOutlet weak var validerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializePage()
    }
    
    func initializePage() {
        
        UserService.shareinstance.getUser { [self] success, user in
            if success {
                currentUserLevel = user?.niveau
                setupLevel(user: user!)
            } else {
                present(Alert.makeServerErrorAlert(),animated: true)
            }
        }
    }
    
    func setupLevel(user: User) {
        levelImage.image = UIImage(named: String(currentLevelIndex!))
        
        LevelService.shareinstance.getLevel(level: currentLevelIndex!, completed: { success, level in
            if success {
                self.activeLevel = level
                self.setupQuestion()
            }
        })
    }
    
    func setupQuestion() {
        print("setting up question .. ")
        
        let levelProgressValue = UserDefaults.standard.array(forKey: "progress")![self.currentLevelIndex!-1] as! Int
        currentQuestionIndex = levelProgressValue
        levelProgress.setProgress(Float(levelProgressValue)/9, animated: true)
        
        if currentQuestionIndex < 9 {
            print("Current question is " + String(currentQuestionIndex))
            activeQuestion = activeLevel?.questions[currentQuestionIndex]
            activeAnswer = activeLevel?.answers[currentQuestionIndex]
            questionLabel.text = activeQuestion
            let score = UserDefaults.standard.array(forKey: "scores")![currentLevelIndex!-1] as! Int
            self.title = "Score : " + String(score)
            activeScore = score
            answerTF.text = ""
        } else {
            
            if activeLevel?.level == 8 {
                print("MAX LEVEL")
            }
            
            var starsGained = 0
            
            if activeScore < 50 {
                
                UserService.shareinstance.updateStats(isLevelingUp: false, resetProgress: true, score: 0, starsGained: 0, forLevel: activeLevel!.level, vieAddition: 0) { success, user in
                    if success {
                        self.present(Alert.makeSingleActionAlert(titre: "Results", message: "Failure, you haven't passed this level, please try again", action: UIAlertAction(
                            title: "Ok", style: .default, handler: { uiaction in
                                self.navigationController?.popToRootViewController(animated: true)
                            })), animated: true
                        )
                    }
                }
            } else {
                
                if activeScore >= 150 {
                    starsGained = 3
                } else if activeScore >= 100 {
                    starsGained = 2
                } else if activeScore >= 50 {
                    starsGained = 1
                } else {
                    starsGained = 0
                }
                
                if !(activeLevel?.level == currentUserLevel)  {
                    UserService.shareinstance.updateStats(isLevelingUp: false, resetProgress: true, score: 0, starsGained: starsGained, forLevel: activeLevel!.level, vieAddition: 0) { success, user in
                        if success {
                            self.present(Alert.makeSingleActionAlert(titre: "Results", message: "Congratulation, you have passed this level and earned " + String(starsGained) + " stars", action: UIAlertAction(
                                title: "Ok", style: .default, handler: { uiaction in
                                    self.navigationController?.popToRootViewController(animated: true)
                                })), animated: true
                            )
                        }
                    }
                }else {
                    UserService.shareinstance.updateStats(isLevelingUp: true, resetProgress: true, score: 0, starsGained: starsGained, forLevel: activeLevel!.level, vieAddition: 0) { success, user in
                        if success {
                            self.present(Alert.makeSingleActionAlert(titre: "Results", message: "Congratulation, you have passed this level and earned " + String(starsGained) + " stars", action: UIAlertAction(
                                title: "Ok", style: .default, handler: { uiaction in
                                    self.navigationController?.popToRootViewController(animated: true)
                                })), animated: true
                            )
                        }
                    }
                }
                
                
            }
        }
    }
    
    func checkPass(cheat: Bool) {
        if activeAnswer != nil {
            LevelService.shareinstance.checkPass(answer: activeAnswer!, userAnswer: answerTF.text!) { success, test in
                if success {
                    
                    var isCorrect = test
                    
                    if cheat {
                        isCorrect = true
                    }
                    
                    if isCorrect! {
                        self.updateUserStats(score: 25, vieAddition: +1, alertTitle: "Congratulation", alertMessage: "You succeded")
                    } else {
                        self.updateUserStats(score: -10, vieAddition: -1, alertTitle: "Failure", alertMessage: "You failed")
                    }
                    
                } else {
                    self.present(Alert.makeServerErrorAlert(),animated: true)
                }
            }
        } else{
            print("answer nil")
        }
        
    }
    
    func updateUserStats(score: Int, vieAddition: Int, alertTitle: String, alertMessage: String) {
        UserService.shareinstance.updateStats(isLevelingUp: false, resetProgress: false, score: score, starsGained: 0, forLevel: self.activeLevel!.level, vieAddition: vieAddition) { success, user in
            
            self.present(Alert.makeSingleActionAlert(titre: alertTitle, message: alertMessage, action: UIAlertAction(
                title: "Ok", style: .default, handler: { uiAction in
                    self.setupQuestion()
                }
            )),animated: true)
        }
    }
    
    @IBAction func speakerAction(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: questionLabel.text!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    @IBAction func validateAction(_ sender: Any) {
        if( self.answerTF.text!.isEmpty ){
            self.present(Alert.makeAlert(titre: "Missing info !", message: "Please make sure to fill the answer field and try again"), animated: true)
            return
        }
        
        checkPass(cheat: false)
    }
    
    @IBAction func cheatAction(_ sender: Any) {
        checkPass(cheat: true)
    }
}

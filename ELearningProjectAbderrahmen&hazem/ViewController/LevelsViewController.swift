//
//  LevelsViewController.swift
//  ELearningProjectAbderrahmen&hazem
//
//  Created by Mac-Mini-2021 on 5/12/2021.
//

import UIKit
import SwiftyJSON
import SAConfettiView
class LevelsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var confettiView: SAConfettiView = SAConfettiView()
    
    var selectedLevel: Int?
    var currentUser: User?
    var levels: [Level] = []
    
    var levelsStars: [[UIImageView]] = []
    
    var imgNames: [String] = []
    
    @IBOutlet weak var levelsCollectionView: UICollectionView!
    @IBOutlet weak var langueButton: UIButton!
    @IBOutlet weak var vieButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "evaluationSegue" {
            let destination = segue.destination as! EvaluationViewController
            destination.currentLevelIndex = selectedLevel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confettiView.frame = self.view.frame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        setupView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        levels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mCell", for: indexPath)
        let contentView = cell.contentView
        
        let imageNiveau = contentView.viewWithTag(1) as! UIImageView
        let starsImages = [contentView.viewWithTag(2), contentView.viewWithTag(3), contentView.viewWithTag(4)] as! [UIImageView]
        
        var user = currentUser!
        
        if currentUser!.progress.count == 0 {
            currentUser!.progress = [0,0,0,0,0,0,0,0,0]
        }
        
        if currentUser!.scores.count == 0 {
            currentUser!.scores = [0,0,0,0,0,0,0,0,0]
        }
        
        if currentUser!.stars.count == 0 {
            currentUser!.stars = [0,0,0,0,0,0,0,0,0]
        }
        
        let level = levels[indexPath.row]
        let star = currentUser?.stars[indexPath.row]
        
        if currentUser!.niveau < level.level {
            imageNiveau.image = UIImage(named: String(level.level) + "g")
            cell.isUserInteractionEnabled = false
        } else {
            imageNiveau.image = UIImage(named: String(level.level))
            cell.isUserInteractionEnabled = true
        }
        
        var i = 0
        for starImage in starsImages {
            if star! > i  {
                print(star! > i)
                starImage.image = UIImage(systemName: "star.fill")
            } else {
                starImage.image = UIImage(systemName: "star")
            }
            i += 1
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedLevel = levels[indexPath.row].level
        performSegue(withIdentifier: "evaluationSegue", sender: selectedLevel)
    }
    
    func setupView(){

        UserService.shareinstance.getUser { [self] success, user in
            
            if success {
                currentUser = user
                
            
                if currentUser?.niveau == 9
                {
                    confettiView.type = .Diamond
                    view.addSubview(confettiView)
                    confettiView.startConfetti()
                }else {
                    print(currentUser?.niveau)
                    print("fassa5")
                    confettiView.stopConfetti()
                    confettiView.removeFromSuperview()
                }
                
                LevelService.shareinstance.getAll { success, levelsFromResult in
                    self.levels = levelsFromResult!
                    
                    levelsCollectionView.reloadData()
                }
                
                let vie = (user?.vie)!
                
                switch user?.langue {
                case "fr":
                    langueButton.setImage(UIImage(named: "flag_fr"), for: .normal)
                    break
                case "de":
                    langueButton.setImage(UIImage(named: "flag_de"), for: .normal)
                    break
                case "it":
                    langueButton.setImage(UIImage(named: "flag_it"), for: .normal)
                    break
                default:
                    break
                }
                
                vieButton.setTitle(String(vie), for: .normal)
                
            } else {
                self.present(Alert.makeServerErrorAlert(),animated: true)
            }
        }
    }
}

//
//  ProfileViewController.swift
//  
//
//  Created by Mac-Mini-2021 on 21/11/2021.
//

import UIKit
import Alamofire
import AlamofireImage


class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var levels : [Level] = []
    var stars : [Int] = []
    var progress : [Int] = []
    var user : User?
    
    @IBOutlet weak var nomP: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var levelsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initializeProfile()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mCell", for: indexPath)
        let contentView = cell.contentView
        
        let levelImage = contentView.viewWithTag(1) as! UIImageView
        let levelDesctiption = contentView.viewWithTag(2) as! UILabel
        let levelProgressbar = contentView.viewWithTag(3) as! UIProgressView
        
        let star1 = contentView.viewWithTag(4) as! UIImageView
        let star2 = contentView.viewWithTag(5) as! UIImageView
        let star3 = contentView.viewWithTag(6) as! UIImageView
        
        let level = levels[indexPath.row]
        
        let starsImages = [star1,star2,star3]
        
        var i = 0
        for starImage in starsImages {
            if stars[level.level - 1 ] > i {
                starImage.image = UIImage(systemName: "star.fill")
            } else {
                starImage.image = UIImage(systemName: "star")
            }
            i += 1
        }
        
        
        levelImage.image = UIImage(named: String(level.level))
        levelProgressbar.setProgress(Float(progress[level.level-1]) / 8, animated: true)
        levelDesctiption.text = "Level " + String(level.level)
        
        return cell
    }
    
    func initializeProfile() {
        print("initializing profile")
        
        UserService.shareinstance.getUser(completed: { [self] isSuccess, user in
            if isSuccess{
                
                UserDefaults.standard.set(user?.name, forKey: "name")
                UserDefaults.standard.set(user?.email, forKey: "email")
                UserDefaults.standard.set(user?._id, forKey: "userID")
                UserDefaults.standard.set(user?.avatar, forKey: "avatar")
                UserDefaults.standard.set(user?.password, forKey: "password")
                
                nomP.text = UserDefaults.standard.string(forKey: "name")!
                
                imageProfile.layer.cornerRadius = imageProfile.frame.size.width/2
                imageProfile.clipsToBounds = true
                
                imageProfile.layer.borderColor = UIColor.white.cgColor
                imageProfile.layer.borderWidth = 5.0
                
                stars = user!.stars
                progress = user!.progress
                
                if user?.avatar != "" {
                    ImageLoader.shared.loadImage(identifier: user!.avatar, url: "http://localhost:8885/user/avatars/" + user!.avatar) { [self] image in
                        imageProfile.image = image
                    }
                }
                
                LevelService.shareinstance.getAll { success, levelsFromResult in
                    self.levels = levelsFromResult!
                    levelsTableView.reloadData()
                }
            }
        })
    }
    
    @IBAction func modifierBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "Modifier", sender: nil)
    }
    
    func testSegue(_ identifier: String!, sender:AnyObject!){
        performSegue(withIdentifier: identifier, sender: sender)
    }
}

//
//  UpdateProfileViewController.swift
//  ELearningProjectAbderrahmen&hazem
//
//  Created by Apple Esprit on 4/12/2021.
//

import UIKit

class UpdateProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var currentPhoto: UIImage?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nomUser: UITextField!
    @IBOutlet weak var EmailUser: UITextField!
    @IBOutlet weak var mdpUser: UITextField!
    @IBOutlet weak var ConfirmMdp: UITextField!
    
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let reachability = try! Reachability()
        
        if reachability.connection == .unavailable {
            self.present(Alert.makeAlert(titre: "Warning", message: "Internet connection is required !"),animated: true)
        } else {
            initialiseProfile()
        }
    }
    
    let name = UserDefaults.standard.string(forKey: "name")!
    let password = UserDefaults.standard.string(forKey: "password")!
    let email = UserDefaults.standard.string(forKey: "email")!
    let userid = UserDefaults.standard.string(forKey: "userID")!
    let avatar = UserDefaults.standard.string(forKey: "avatar")!
    
    func initialiseProfile() {
        print("initializing profile")
        
        self.nomUser.text = name
        self.EmailUser.text = email
        self.mdpUser.text = password
        self.ConfirmMdp.text = password
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true

        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 5.0
        print(avatar)
        print(" zeaze ")
        if avatar != "" {
            ImageLoader.shared.loadImage(identifier: avatar, url: "http://localhost:8885/user/avatars/" + avatar) { [self] image in
                profileImage.image = image
            }
        }
    }
    
    @IBAction func updateBtn(_ sender: Any) {
        let name2 = self.nomUser.text!
        let email2 = self.EmailUser.text!
        let password2 = self.mdpUser.text!
        
        UserService.shareinstance.updateProfile(name: name2, email: email2, password: password2) { isSuccess in
            if isSuccess{
                self.present(Alert.makeAlert(titre: "Alert", message: "User updated successfully"), animated: true)
            } else {
                self.present(Alert.makeAlert(titre: "Alert", message: "Please try again "), animated: true)
            }
        }
    }
    
    func camera()
    {
        let myPickerControllerCamera = UIImagePickerController()
        myPickerControllerCamera.delegate = self
        myPickerControllerCamera.sourceType = UIImagePickerController.SourceType.camera
        myPickerControllerCamera.allowsEditing = true
        self.present(myPickerControllerCamera, animated: true, completion: nil)
    }
    
    
    func gallery()
    {
        let myPickerControllerGallery = UIImagePickerController()
        myPickerControllerGallery.delegate = self
        myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerControllerGallery.allowsEditing = true
        self.present(myPickerControllerGallery, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            
            return
        }
        
        currentPhoto = selectedImage
        UserService.shareinstance.changeAvatar(uiImage: selectedImage,completed: { [self] success in
            if success {
                profileImage.image = selectedImage
                self.present(Alert.makeAlert(titre: "Succes", message: "Photo modifié avec succés"),animated: true)
            } else {
                self.present(Alert.makeServerErrorAlert(),animated: true)
            }
        })
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func showActionSheet(){
        
        let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("Upload Image", comment: ""), message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.black
        let cancelActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default)
        { action -> Void in
            self.camera()
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Choose From Gallery", comment: ""), style: .default)
        { action -> Void in
            self.gallery()
        }
        
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    // ACTIONS
    @IBAction func changeProfilePic(_ sender: Any) {
        showActionSheet()
    }
    
}

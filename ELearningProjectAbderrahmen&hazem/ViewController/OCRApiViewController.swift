//
//  OCRApiViewController.swift
//  ELearningProjectAbderrahmen&hazem
//
//  Created by Mac-Mini-2021 on 8/12/2021.
//

import UIKit
import PhotosUI

class OCRApiViewController: UIViewController {

    
    var currentImage: UIImage?
    
    @IBOutlet weak var libraryBtn: UIButton!
    
    @IBOutlet weak var result: UITextView!
    
   @IBOutlet weak var langue: UITextField!
    
    @IBOutlet weak var imageup: UIImageView!
    

    var imagePicker = UIImagePickerController()
    var libraryPicker: PHPickerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        result.isUserInteractionEnabled = false
        setupLibrary()
    }
    
    
    
    @IBAction func cameraBtnPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func libraryBtnPressed(_ sender: Any) {
        present(libraryPicker!, animated: true, completion: nil)
    }
    
    
    @IBAction func envoyer(_ sender: Any) {
        
        if currentImage == nil {
            self.present(Alert.makeAlert(titre: "Warning", message: "Please choose an image"), animated: true)
        } else {
            ocrService().addPublication(publication: langue.text!, uiImage: currentImage!, completed: { sucess, resultString in
                self.result.text = resultString
                
            })
        }
        
    }
    
    

}



extension OCRApiViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setupCamera() {
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.imageup.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension OCRApiViewController:  PHPickerViewControllerDelegate {
    
    func setupLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .automatic
        libraryPicker = PHPickerViewController(configuration: configuration)
        libraryPicker!.delegate = self
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        if let first = results.first {
            let newItem = first.itemProvider
            if newItem.canLoadObject(ofClass: UIImage.self) {
                newItem.loadObject(ofClass: UIImage.self) { image, error in
                    if let newImage = image as? UIImage {
                        DispatchQueue.main.async { [self] in
                            self.imageup.image = newImage
                            currentImage = newImage
                        }
                    }
                }
            }
        }
    }
     
}

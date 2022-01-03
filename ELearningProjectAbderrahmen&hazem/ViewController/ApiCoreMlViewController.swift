//
//  ApiCoreMlViewController.swift
//  ELearningProjectAbderrahmen&hazem
//
//  Created by Mac-Mini-2021 on 27/11/2021.
//

import UIKit
import PhotosUI
import Vision

class ApiCoreMlViewController: UIViewController , PHPickerViewControllerDelegate {

    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var imageToAnalyze: UIImageView!
    
    var picker: PHPickerViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker = PHPickerViewController(configuration: setupConfiguration())
        picker?.delegate = self
    }
    
    func setupConfiguration() -> PHPickerConfiguration {
        var config = PHPickerConfiguration()
        config.preferredAssetRepresentationMode = .automatic
        config.selectionLimit = 1
        config.filter = .images
        return config
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }
        let item = result.itemProvider
        guard item.canLoadObject(ofClass: UIImage.self) else { return }
        item.loadObject(ofClass: UIImage.self) { bridgeable, error in
            if let e = error {
                print("Nous avons une erreur: \(e.localizedDescription)")
            }
            if let newImage = bridgeable as? UIImage {
                DispatchQueue.main.async {
                    self.imageToAnalyze.image = newImage
                }
            }
        }
    }
    
    
    func getCoreML() -> VNCoreMLModel? {
        let configuration: MLModelConfiguration = MLModelConfiguration()
        do {
         let ml = try SqueezeNet_2(configuration: configuration)
            let model = try VNCoreMLModel(for: ml.model)
            return model
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
    func getCiImage() -> CIImage? {
        if let image = imageToAnalyze.image {
            if let ciImage = CIImage(image: image) {
                //2. Convertir image
                return ciImage
            }
            print("Ci ne fonctionne pas")
            return nil
        }
        print("No image")
        return nil
    }
    
    func setupRequest(_ model: VNCoreMLModel) -> VNCoreMLRequest {
        return VNCoreMLRequest(model: model, completionHandler: setupResultHandler(_:_:))
    }
    
    func setupResultHandler(_ vnRequest: VNRequest, _ error: Error?){
        //5. Obtenir les résultats.
        let results = vnRequest.results as? [VNClassificationObservation]
        if let bestMatch = results?.first {
            let string = "Je suis certain à \(Int(bestMatch.confidence * 100))% que ceci est : \(bestMatch.identifier)"
            self.updateLabel(string)
        }
    }
    
    func setupHandler(_ image: CIImage, _ request: VNCoreMLRequest) {
    //4. Faire cette requete Vision
    DispatchQueue.global(qos: .userInitiated).async {
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("On n'a pas pu faire le perform: \(error.localizedDescription)")
        }
    }
    }
    
    func updateLabel(_ string: String) {
        DispatchQueue.main.async {
            self.predictionLabel.text = string
        }
    }
        
    
    @IBAction func addPicture(_ sender: Any) {
        present(picker!, animated: true, completion: nil)
    }
    
     @IBAction func analyzePicture(_ sender: Any) {
        //1. Soit sur d'avoir une image
        guard let ciImage = getCiImage() else { return }
        //3. Mettre en place une requete vision
      guard let model = getCoreML() else { return}
        let request = setupRequest(model)
        setupHandler(ciImage, request)
    }
    
}

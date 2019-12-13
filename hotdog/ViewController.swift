//
//  ViewController.swift
//  hotdog
//
//  Created by baykan on 11/12/2019.
//  Copyright © 2019 baykan. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
       if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
        guard let ciimage = CIImage(image:userPickedImage) else{
            fatalError("Could not convert UIImage into CIImage ... sorry bro!")
        }
        detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image:CIImage){
        guard  let model = try? VNCoreMLModel(for:Inceptionv3().model) else{
            fatalError("Loading CoreML model Failed... :(")
        }
        
        let request = VNCoreMLRequest(model:model){(request,error)in
            guard let results = request.results as? [VNClassificationObservation] else{
            fatalError("Model Failed to Process image")
            }
            
            print(results)
            
            if let firstResult = results.first{
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "HotDog! 🌭 "
                }else if firstResult.identifier.contains("pizza") {
                    self.navigationItem.title = "Pizza! 🍕 "
                }
                else {
                    self.navigationItem.title = "not Hotdog! and not Pizza!"
                }
            }
            }
        let handler = VNImageRequestHandler(ciImage:image)
        do {
        try handler.perform([request])
        }
        catch{
            print(error)
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
         present(imagePicker,animated:true,completion:nil)
    }
    
}


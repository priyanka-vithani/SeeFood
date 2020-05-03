//
//  ViewController.swift
//  SeeFood
//
//  Created by Apple on 02/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var btnCamera: UIBarButtonItem!
    @IBOutlet weak var img: UIImageView!
    
    let imgPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPicker.delegate = self
        imgPicker.sourceType = .photoLibrary
        imgPicker.allowsEditing = false
    }

    @IBAction func btnCamera_clk(_ sender: UIBarButtonItem) {
        present(imgPicker, animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
      
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("loading coreML model filed")
        }
        
        let request = VNCoreMLRequest(model: model) { (req, err) in
            guard let results = req.results as? [VNClassificationObservation] else{
                fatalError("model failed to process image")
            }
            if let firstResult = results.first{
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "Hotdog!!"
                }else{
                    self.navigationItem.title = "Not Hotdog!!"
                }
            }
            print(results)
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([request])
        }catch{
            print(error)
        }
    }
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            img.image = userPickedImg
            guard let ciimage = CIImage(image: userPickedImg) else{
                fatalError("could not convert uiimage into ciimage")
            }
            detect(image: ciimage)
            
            
        }
        imgPicker.dismiss(animated: true, completion: nil)
        
    }
    
    
}

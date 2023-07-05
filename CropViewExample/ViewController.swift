//
//  ViewController.swift
//  CropViewExample
//
//  Created by Bhavesh Chaudhari on 07/05/20.
//  Copyright © 2020 Bhavesh. All rights reserved.
//

import UIKit
import CIrcleCropView


class ViewController: UIViewController {
    var imagePicker: ImagePicker!
    @IBOutlet var selecImageBtn: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraBtn: UIButton!
    @IBOutlet var galleryBtn: UIButton!
    @IBOutlet var popUpView: UIView!
    @IBOutlet var onclickImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.isHidden = true
    
//        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(ImageTap))
//        imageView.addGestureRecognizer(imageTapGesture)
     
    }

    override func viewDidLayoutSubviews() {
//        imageView.layer.cornerRadius = imageView.frame.width/2
//        imageView.clipsToBounds = true
    }
    
    
    @IBAction func selecImageBtnAction(_ sender: Any) {
        
        // Toggle the visibility of the views
        let isHidden = popUpView.isHidden
        popUpView.isHidden = !isHidden
        // Define the initial and final positions for the animation
        let initialYPosition = self.view.frame.height
        let finalYPosition = self.view.frame.height - popUpView.frame.height
        // Set the initial position of the views
        popUpView.frame.origin.y = initialYPosition
        // Perform the animation
        UIView.animate(withDuration: 0.3) {
            self.popUpView.frame.origin.y = isHidden ? finalYPosition : initialYPosition
        }
    }
    
    @IBAction func selectImageClick(sender: UIButton) {
        self.openCameraActionSheet { cameraState in
            if let state = cameraState {
                self.openImagePicker(with: state)
            }
        }
    }
    
    
    @IBAction func cameraBtnAction(_ sender: Any)
    {
        self.openImagePicker(with: .camera)
    }
    
    @IBAction func galleryBtnAction(_ sender: Any)
    {
        self.openImagePicker(with: .gallary)
    }
    
    private func presentCropViewController(with Image: UIImage) {
        let cropViewController = CropViewController(image: Image) { [unowned self] croppedImage in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let capturedImageVC = storyboard.instantiateViewController(withIdentifier: "CapturedImageViewController") as! CapturedImageViewController
           

            if let navigationController = self.navigationController {
                navigationController.pushViewController(capturedImageVC, animated: true)
                capturedImageVC.capturedimage = croppedImage!
            }
            
            var cropimage = croppedImage

        }
       
        
        cropViewController.modalPresentationStyle = .fullScreen
        self.present(cropViewController, animated: true, completion: nil)
    }

    /// function responsible for open ImagePicker with selected action for camera state
    /// - Parameter state: camera state enum contain two case 1. camera 2.gallary
    private func openImagePicker(with state: CameraState) {
        self.imagePicker = ImagePicker(fromController: self, state: state, compltionClouser: { [unowned self] pickupResult in
            switch pickupResult {
            case .success(let selectedImage):
                DispatchQueue.main.async {
                    self.presentCropViewController(with: selectedImage)
                }
            case .error(let message):
                self.presentAlertMessage(message: message)
            }
        })
    }
}

extension ViewController {
    func openCameraActionSheet(compltion:@escaping (CameraState?) -> Void) {
        let cameraActionSheet = UIAlertController(title: "", message: "Select Option", preferredStyle: .actionSheet)

        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            compltion(.camera)
        }

        let gallaryAction = UIAlertAction(title: "Gallary", style: .default) { _ in
            compltion(.gallary)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            compltion(nil)
        }
        cameraActionSheet.addAction(cameraAction)
        cameraActionSheet.addAction(gallaryAction)
        cameraActionSheet.addAction(cancelAction)

        if let popoverController = cameraActionSheet.popoverPresentationController {
           popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
        }

        self.present(cameraActionSheet, animated: true, completion: nil)
    }

    /// The Function present Alert Controller with given message,Title and clouser.
    /// - Parameter title: title for alert Controller
    /// - Parameter message: message for alert Controller
    /// - Parameter okclick: Clouser for okay button
    func presentAlertMessage(title: String = "Alert", message: String, okclick: (() -> Void)? = nil) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
                if okclick != nil {
                    okclick!()
                }
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true) {
            }
        }
}


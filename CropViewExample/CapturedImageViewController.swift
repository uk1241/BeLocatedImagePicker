//
//  CapturedImageViewController.swift
//  CropViewExample
//
//  Created by R.Unnikrishnan on 03/07/23.
//  Copyright © 2023 Bhavesh. All rights reserved.
//

import UIKit

class CapturedImageViewController: UIViewController {
    @IBOutlet var descriptionView: UIView!
    @IBOutlet var croppedImageView: UIImageView!
    var capturedimage: UIImage = UIImage()
    @IBOutlet var continueBtn: UIButton!
    @IBOutlet var doneView: UIView!
    @IBOutlet var onclickBgImage: UIImageView!
    @IBOutlet var doneBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        onclickBgImage.isHidden = true
        doneView.isHidden = true
        //to give corder radius at the right top of the view
        doneView.clipsToBounds = true
        doneView.layer.cornerRadius = 24
        doneView.layer.maskedCorners = [.layerMaxXMinYCorner]
        croppedImageView.image = capturedimage
        // Make the imageView circular
        croppedImageView.layer.cornerRadius = croppedImageView.bounds.width / 2
        croppedImageView.clipsToBounds = true
        continueBtn.addRoundCorner(radius: 25, borderWidth: 0, borderColor: UIColor.black)
        //why we ask photo view
        descriptionView.layer.cornerRadius = 16
        descriptionView.addBorder(withHexColor: "#FFCD00")
        //donebutton
        doneBtn.addRoundCorner(radius: 17.5, borderWidth: 0, borderColor: UIColor.black)
        
    }
    
    
    @IBAction func continueBtnAction(_ sender: Any)
    {
        
        onclickBgImage.isHidden = false
        let isHidden = doneView.isHidden
        doneView.isHidden = !isHidden
        // Define the initial and final positions for the animation
        let initialYPosition = self.view.frame.height
        let finalYPosition = self.view.frame.height - doneView.frame.height
        // Set the initial position of the views
        doneView.frame.origin.y = initialYPosition
        // Perform the animation
        UIView.animate(withDuration: 0.3) {
            self.doneView.frame.origin.y = isHidden ? finalYPosition : initialYPosition
        }
    }
    @IBAction func doneBtnAction(_ sender: UIButton)
    {
        doneView.isHidden = true
        onclickBgImage.isHidden = true
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
//button extension for rounded corners and Border color
extension UIButton {
    func addRoundCorner(radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = true
    }
}


extension UIColor {
    convenience init(hexString: String) {
        var hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


extension UIView {
    func applyGradient(withHexColors hexColors: [String], borderColorHex: String?, borderWidth: CGFloat = 0.0) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        var colors: [CGColor] = []
        for hexColor in hexColors {
            colors.append(UIColor(hexString: hexColor).cgColor)
        }
        
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        if let borderColorHex = borderColorHex {
            layer.borderColor = UIColor(named: borderColorHex)?.cgColor
            layer.borderWidth = borderWidth
        }
    }
}
extension UIView {
    func addBorder(withHexColor hexColor: String, borderWidth: CGFloat = 0.5) {
        layer.borderColor = UIColor(hexString: hexColor).cgColor
        layer.borderWidth = borderWidth
    }
}


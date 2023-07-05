//
//  CircleCropView.swift
//  CIrcleCropView Test
//
//  Created by Bhavesh Chaudhari on 08/05/20.
//  Copyright © 2020 Bhavesh. All rights reserved.
//

import UIKit


public class CircleCropView: UIView {


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.58)
        isUserInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func calculateCircleInset(in rect: CGRect) -> CGRect {
        let minSize = min(rect.width, rect.height)
        let holeSize = CGSize(width: minSize - 30, height: minSize - 30) // Adjust the size of the hole by changing the subtraction value
        
        let holeOrigin = CGPoint(x: (rect.width - holeSize.width) / 2, y: (rect.height - holeSize.height) / 2)
        let holeRect = CGRect(origin: holeOrigin, size: holeSize)
        return holeRect
    }

    var circleInset: CGRect {
        return calculateCircleInset(in: bounds)
    }

    override public func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        
        let holeInset = circleInset
        
        context.addEllipse(in: holeInset)
        context.clip()
        
        context.clear(holeInset)
        let bundle = Bundle(for: CircleCropView.self)
        
        context.draw(UIImage(named: "profile_boarder.png", in: bundle, compatibleWith: nil)!.cgImage!, in: holeInset)
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(holeInset)
        
        context.setStrokeColor(UIColor.clear.cgColor)
        context.strokeEllipse(in: holeInset)
        
        context.restoreGState()
    }


//    override public func draw(_ rect: CGRect) {
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//        context.saveGState()
//        let holeInset = circleInset
//        context.addRect(holeInset)
//        context.clip()
//        context.clear(holeInset)
//        let bundel = Bundle(for: CircleCropView.self)
//
//        context.draw(UIImage(named: "profile_boarder.png",in: bundel,compatibleWith: nil)!.cgImage!, in: holeInset)
//        context.setFillColor(UIColor.clear.cgColor)
//        context.fill( holeInset)
//        context.setStrokeColor(UIColor.clear.cgColor)
//        context.strokeEllipse(in: holeInset)
//        context.restoreGState()
//    }
}

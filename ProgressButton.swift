//
//  ProgressButton.swift
//  animationButton
//
//  Created by Fredde on 2014-09-16.
//  Copyright (c) 2014 se.fredrik-andersson. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable class ProgressButton: UIButton {
    
    var posCenter = CGPoint()
    var progressCircle = CAShapeLayer()
    var circleRadius = CGFloat()
    var circlePath = UIBezierPath()
    
    var borderView: UIView!
    
    var startAnimation: NSTimeInterval!
    var endAnimation: NSTimeInterval!
    
    var originalFrame: CGRect!
    var smallFrame: CGRect!
    
    var isLoading = false
    
    @IBInspectable var start: Double = 2.0 {
        didSet {
            startAnimation = start
        }
    }
    
    @IBInspectable var end: Double = 2.0 {
        didSet {
            endAnimation = end
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.blueColor() {
        didSet {
            borderView.layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2 {
        didSet {
            borderView.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            borderView.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var textColor: UIColor = UIColor.blueColor() {
        didSet{
            self.setTitleColor(textColor, forState: .Normal)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        
        clipsToBounds = true
        layer.cornerRadius = bounds.height * 0.5
        
        borderView = UIView(frame: bounds)
        borderView.userInteractionEnabled = false
        borderView.clipsToBounds = true
        borderView.layer.cornerRadius = cornerRadius
        addSubview(borderView)
    
        self.addTarget(self, action: "highlight", forControlEvents: UIControlEvents.TouchDown)
        self.addTarget(self, action: "highlight", forControlEvents: UIControlEvents.TouchDragEnter)
        self.addTarget(self, action: "unhighlight", forControlEvents: UIControlEvents.TouchCancel)
        self.addTarget(self, action: "unhighlight", forControlEvents: UIControlEvents.TouchDragExit)
        self.addTarget(self, action: "unhighlight", forControlEvents: UIControlEvents.TouchUpInside)
        self.addTarget(self, action: "unhighlight", forControlEvents: UIControlEvents.TouchUpOutside)
        
    }
    
    func highlight() {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.backgroundColor = self.borderColor
        })
        
    }
    
    func unhighlight() {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.backgroundColor = UIColor.clearColor()
        })
        
    }
    
    func startLoading() {
        
        originalFrame = frame
        smallFrame = frame
        smallFrame.size.width = smallFrame.height
        smallFrame.origin.x += (originalFrame.width - originalFrame.height) * 0.5
        
        userInteractionEnabled = false
        
        UIView.animateWithDuration(startAnimation, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .CurveEaseOut, animations: { () -> Void in
            
            self.frame = self.smallFrame
            self.borderView.frame = self.bounds
            
            self.layer.backgroundColor = UIColor.clearColor().CGColor
            self.borderView.layer.backgroundColor = UIColor.clearColor().CGColor
            self.borderView.layer.borderColor = UIColor.grayColor().CGColor
            
            self.titleLabel!.alpha = 0.0
            
        }, completion:{
            (finished: Bool) in
            
            if finished {
                
                UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .CurveEaseOut, animations: { () -> Void in
                    
                    self.isLoading = true
                    
                    self.posCenter = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
                    self.circleRadius = self.bounds.height * 0.5 - self.borderWidth * 0.5
                    self.circlePath = UIBezierPath(arcCenter: self.posCenter, radius: self.circleRadius, startAngle: CGFloat(-0.5 * M_PI), endAngle: CGFloat(1.5 * M_PI), clockwise: true)
                    
                    self.progressCircle.path = self.circlePath.CGPath
                    self.progressCircle.strokeColor = self.borderColor.CGColor
                    self.progressCircle.fillColor = UIColor.clearColor().CGColor
                    self.progressCircle.lineWidth = self.borderWidth
                    self.progressCircle.strokeStart = 0
                    self.progressCircle.strokeEnd = 0
                    
                    self.layer.insertSublayer(self.progressCircle, above: self.borderView.layer)
                    
                    }, completion:nil)
                
            }
        })
    }
    
    func setProgress(progress: CGFloat) {
        
        if isLoading {
            progressCircle.strokeEnd = progress
        }
        
    }
    
    func stopLoadingWithSuccess(success: Bool) {
        
        isLoading = false
        
        UIView.animateWithDuration(endAnimation, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .CurveEaseOut, animations: { () -> Void in
            
            self.frame = self.originalFrame
            self.borderView.frame = self.bounds
            
            self.backgroundColor = self.borderColor
            
            self.progressCircle.opacity = 0.0
            self.borderView.layer.borderColor = self.borderColor.CGColor
            
            self.titleLabel!.alpha = 1.0
            self.setTitle("Success!", forState: .Normal)
            self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            
        }, completion: nil)
        
        userInteractionEnabled = true
        
    }
    
}

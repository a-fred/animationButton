//
//  ViewController.swift
//  animationButton
//
//  Created by Fredde on 2014-09-16.
//  Copyright (c) 2014 se.fredrik-andersson. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var progressButton: ProgressButton!
    var progress: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func onButton() {
        
        progress = 0
        
        progressButton.startLoading()
        onTimer()
        
    }
    
    func onTimer() {
        
        progress += 0.03
        
        if progress < 1 {
            
            progressButton.setProgress(progress)
            NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "onTimer", userInfo: nil, repeats: false)
            
        } else {
            
            progressButton.stopLoadingWithSuccess(true)
            
        }
    }

}


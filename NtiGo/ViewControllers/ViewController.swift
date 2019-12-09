//
//  ViewController.swift
//  NtiGo
//
//  Created by Levent Özkan on 21.11.2019.
//  Copyright © 2019 Levent Özkan. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var ctslogo: UIImageView!
    @IBOutlet weak var ntilogo: UIImageView!
    @IBOutlet weak var titleTxt: UILabel!
    
    var timer = Timer()
    var counter = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
     
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerfunction), userInfo: nil, repeats: true)
        
        UIView.animate(withDuration: 2, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            let ctsPoint = CGPoint(x: 300, y: self.ctslogo.center.y)
            let ntiPoint = CGPoint(x: -300, y: self.ntilogo.center.y)
            let titlePoint = CGPoint(x: self.titleTxt.center.x, y: 300)
            self.ctslogo.center = ctsPoint
            self.ntilogo.center = ntiPoint
            self.titleTxt.center = titlePoint
        }, completion: nil)

        
        
    }
    
    @objc func timerfunction(){
        
        counter-=1
        if counter == 0{
            performSegue(withIdentifier: "toFirstScreen", sender: nil)
            
        }
        
    }
    
   
        
     
        
    }





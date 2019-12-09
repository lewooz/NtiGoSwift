//
//  AlertDialogue.swift
//  NtiGo
//
//  Created by Levent Özkan on 28.11.2019.
//  Copyright © 2019 Levent Özkan. All rights reserved.
//

import Foundation
import UIKit


fileprivate var window : UIView?

extension UIViewController{
    
    
    
    func showDialog(){
        
        window = UIView(frame: self.view.bounds)
      
        window!.layer.backgroundColor = UIColor.init(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.75).cgColor
        
        
        let alertDialog = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        
        alertDialog.center = window!.center
        let label = UILabel()
        //label.center = view.center
        label.frame = CGRect(x: 140, y: alertDialog.frame.maxY+10, width: 150, height: 50)
        label.textAlignment = NSTextAlignment.center
        label.text = "Please Wait..."
        label.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        alertDialog.startAnimating()
        
        window!.addSubview(alertDialog)
        window!.addSubview(label)
        self.view.addSubview(window!)
    }
    
    func dismissDialog(){
        
        window?.removeFromSuperview()
        window = nil
        
        
    }
    
}

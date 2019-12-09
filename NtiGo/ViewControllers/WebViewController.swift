//
//  WebViewController.swift
//  NtiGo
//
//  Created by Levent Özkan on 7.12.2019.
//  Copyright © 2019 Levent Özkan. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    var fillForm = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var component = URLComponents(string: "http://147.0.27.197/")
      
        let newUrl = component?.url
        let request = URLRequest(url: newUrl!)
        
        webView.navigationDelegate = self
        
        self.webView.load(request)
        
    }
   
    
    @IBAction func deneme(_ sender: Any) {
        
        
     
}
}

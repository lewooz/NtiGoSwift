//
//  DeviceDetailVC.swift
//  NtiGo
//
//  Created by Levent Özkan on 25.11.2019.
//  Copyright © 2019 Levent Özkan. All rights reserved.
//

import UIKit

class DeviceDetailVC: UIViewController{

    @IBOutlet weak var cencorsButton: UIButton!
          
    @IBOutlet weak var exteriorCensorsButton: UIButton!
    @IBOutlet weak var digitalInputButton: UIButton!
    @IBOutlet weak var ipDevicesButton: UIButton!
    
    @IBOutlet weak var firmwareTxt: UILabel!
    @IBOutlet weak var uptimeTxt: UILabel!
    @IBOutlet weak var modelNametxt: UILabel!
    @IBOutlet weak var deviceNametxt: UILabel!
    
    
    @IBOutlet weak var titleView: UIView!
    
    var username = ""
    var password = ""

    var selectedDeviceNameTxt = ""
    var selectedDeviceModelTxt = ""
    var selectedDeviceUptimeTxt = ""
    var selectedDeviceFirmwareTxt = ""
    
    var selectedDeviceOnlyNameTxt = ""
    var selectedDeviceonlyModelTxt = ""
    var selectedDeviceOnlyUptimeTxt = ""
    var selectedDeviceOnlyFirmwareTxt = ""
    var ipNumber = ""
    
    var censorArray = [interiorCensor]()
    var ipDevArray = [ipDev]()
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
           
        return .lightContent
           
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        cencorsButton.layer.backgroundColor = UIColor.clear.cgColor
        
        let mutableDeviceNameTxt = NSMutableAttributedString(string: selectedDeviceNameTxt)
        mutableDeviceNameTxt.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange.init(location: 0, length: 12))
        
        
        let mutableModelNameTxt = NSMutableAttributedString(string: selectedDeviceModelTxt)
        mutableModelNameTxt.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange.init(location: 0, length: 6))
        
        let mutableDeviceUptimeTxt = NSMutableAttributedString(string: selectedDeviceUptimeTxt)
        mutableDeviceUptimeTxt.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange.init(location: 0, length: 7))
        
        let mutableDeviceFirmwareTxt = NSMutableAttributedString(string: selectedDeviceFirmwareTxt)
        mutableDeviceFirmwareTxt.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange.init(location: 0, length: 9))
        
        deviceNametxt.attributedText = mutableDeviceNameTxt
        modelNametxt.attributedText = mutableModelNameTxt
        uptimeTxt.attributedText = mutableDeviceUptimeTxt
        firmwareTxt.attributedText = mutableDeviceFirmwareTxt
        
        
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        animateAll()
        NotificationCenter.default.addObserver(self, selector: #selector(animateAll), name: UIApplication.willEnterForegroundNotification, object: nil)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false

    }
    
   
    
    @objc func animateAll(){
        
        animateButton(imageString1: "dr1", imageString2: "dr2", imageString3: "dr3", button: self.cencorsButton)
        animateButton(imageString1: "hr1", imageString2: "hr2", imageString3: "hr3", button: self.exteriorCensorsButton)
        animateButton(imageString1: "kr1", imageString2: "kr2", imageString3: "kr3", button: self.digitalInputButton)
        animateButton(imageString1: "ir1", imageString2: "ir2", imageString3: "ir3", button: self.ipDevicesButton)
        animateTitle()
        
    }
  
    func animateTitle(){
        
        
        let image1 = UIImage(named: "infobanner1")
        let image2 = UIImage(named: "infobanner2")
        let image3 = UIImage(named: "infobanner3")
        
         let imageArray = [image2,image3]
        
        let i = Int.random(in: (0...1))
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.contents))
        animation.fromValue = image1?.cgImage
        animation.toValue = imageArray[i]?.cgImage
        animation.duration = 2
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        
        self.titleView.layer.add(animation, forKey: "titleAnimation")

    }
    
    func animateButton(imageString1 : String,imageString2 : String,imageString3 : String, button : UIButton){
        
        
        
        let image = UIImage(named: imageString1)
        let image2 = UIImage(named: imageString2)
        let image3 = UIImage(named: imageString3)
        
        let imageArray = [image2,image3]
          
         
          let animation :CABasicAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.contents))
        
         let i = Int.random(in: 0...1)
 
          animation.fromValue = image?.cgImage
         animation.toValue = imageArray[i]?.cgImage
          animation.duration = 2
          animation.repeatCount = Float.infinity
         animation.autoreverses = true
          
          button.layer.add(animation, forKey: "animateContents")
          //self.cencorsButton.setBackgroundImage(image2, for: UIControl.State.normal)
        
    }
    
    @IBAction func interiorCensorDetails(_ sender: Any) {
        
        censorArray.removeAll()
        self.showDialog()
        
        let session = URLSession.shared
        var urlComponent = URLComponents(string: "http://\(ipNumber)/goform/login")
        urlComponent?.queryItems = [URLQueryItem(name: "username", value: username),URLQueryItem(name: "password", value: password)]
        
        let loginUrl = urlComponent?.url
        
        let task = session.dataTask(with: loginUrl!) { (data, response, error) in
            if error != nil {
                
                print(error)
            }else{ if data != nil {
                
                do{
                let cookieResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                    
                    
                    DispatchQueue.main.async {
                        
                        if let cookie = cookieResponse["cookie"] as? String{
                            print(cookie)
                            self.secondInteriorCensorCall(cookie: cookie, ipNumber: self.ipNumber)
                        }
                    }
                    
                }catch{
                    print(error.localizedDescription)
                }
                }
                
                
            }
        }
        task.resume()

        
    }
    
    func  secondInteriorCensorCall(cookie : String , ipNumber : String){
        
        let session = URLSession.shared
        
        let url = URL(string: "http://\(ipNumber)/json/get/appISens.json")!
        var request = URLRequest(url: url)
        request.addValue(cookie, forHTTPHeaderField: "cookie")

        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                
                print(error?.localizedDescription)
            }else{
                if data != nil {
                    
                    do{
                    let dataResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                        
                        DispatchQueue.main.sync {
                            guard let dataString = dataResponse["data"] as? Dictionary<String , Any> else {return}
                           
                            guard let censorDetailArray = dataString["isens"] as? [[String: Any]] else {return}
                            
                            
                            for censor in censorDetailArray{
                                
                                let desc = censor["desc"] as! String
                                let val = censor["val"] as! String
                                let status = censor["status"] as! Int
                                
                                let interiorCensorObject : interiorCensor = interiorCensor(description: desc, alarmStatus: status, value: val)
                               
                                self.censorArray.append(interiorCensorObject)
                                
                                
                            }
                            self.dismissDialog()
                            self.performSegue(withIdentifier: "toInterior", sender: nil)
                        }
                        
                        
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                }
                
            }
        }
        task.resume()

      
    }
    
    
    @IBAction func exteriorCensorDetails(_ sender: Any) {
        
        censorArray.removeAll()
        self.showDialog()
        
        let session = URLSession.shared
        var urlComponent = URLComponents(string: "http://\(ipNumber)/goform/login")
        urlComponent?.queryItems = [URLQueryItem(name: "username", value: username),URLQueryItem(name: "password", value: password)]
        
        let loginUrl = urlComponent?.url
        
        let task = session.dataTask(with: loginUrl!) { (data, response, error) in
            if error != nil {
                
                print(error)
            }else{ if data != nil {
                
                do{
                let cookieResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                    
                    
                    DispatchQueue.main.async {
                        
                        if let cookie = cookieResponse["cookie"] as? String{
                            print(cookie)
                            self.secondExteriorCensorCall(cookie: cookie, ipNumber: self.ipNumber)
                        }
                    }
                    
                }catch{
                    print(error.localizedDescription)
                }
                }
                
                
            }
        }
        task.resume()
        
    }
    
    func secondExteriorCensorCall(cookie : String, ipNumber : String){
        
        print(ipNumber)
        let session = URLSession.shared
        
        let url = URL(string: "http://\(ipNumber)/json/get/appESens.json")!
        var request = URLRequest(url: url)
        request.addValue(cookie, forHTTPHeaderField: "cookie")

        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                
                print(error?.localizedDescription)
            }else{
                if data != nil {
                    
                    do{
                    let dataResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                        
                        DispatchQueue.main.sync {
                            guard let dataString = dataResponse["data"] as? Dictionary<String , Any> else {return}
                           
                            guard let censorDetailArray = dataString["esens"] as? [[String: Any]] else {return}
                            
                            
                            for censor in censorDetailArray{
                                
                                let desc = censor["desc"] as! String
                                let val = censor["val"] as! String
                                let status = censor["status"] as! Int
                                
                                let interiorCensorObject : interiorCensor = interiorCensor(description: desc, alarmStatus: status, value: val)
                               
                                self.censorArray.append(interiorCensorObject)
                                
                                
                            }
                            self.dismissDialog()
                            self.performSegue(withIdentifier: "toExterior", sender: nil)
                        }
                        
                        
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                }
                
            }
        }
        task.resume()

      
    }
 
    @IBAction func digitalInputDetails(_ sender: Any) {
        
        censorArray.removeAll()
        self.showDialog()
        
        let session = URLSession.shared
        var urlComponent = URLComponents(string: "http://\(ipNumber)/goform/login")
        urlComponent?.queryItems = [URLQueryItem(name: "username", value: username),URLQueryItem(name: "password", value: password)]
        
        let loginUrl = urlComponent?.url
        
        let task = session.dataTask(with: loginUrl!) { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            }else{ if data != nil {
                
                do{
                let cookieResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                    
                    
                    DispatchQueue.main.async {
                        
                        if let cookie = cookieResponse["cookie"] as? String{
                            print(cookie)
                            self.secondDigitalCall(cookie: cookie, ipNumber: self.ipNumber)
                        }
                    }
                    
                }catch{
                    print(error.localizedDescription)
                }
                }
                
                
            }
        }
        task.resume()
        
    }
    
    func secondDigitalCall(cookie : String, ipNumber : String){
        
        print(ipNumber)
        let session = URLSession.shared
        
        let url = URL(string: "http://\(ipNumber)/json/get/appDiginp.json")!
        var request = URLRequest(url: url)
        request.addValue(cookie, forHTTPHeaderField: "cookie")

        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            }else{
                if data != nil {
                    
                    do{
                    let dataResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                        
                        DispatchQueue.main.sync {
                            guard let dataString = dataResponse["data"] as? Dictionary<String , Any> else {return}
                           
                            guard let censorDetailArray = dataString["diginp"] as? [[String: Any]] else {return}
                            
                            
                            for censor in censorDetailArray{
                                
                                let desc = censor["desc"] as! String
                                let val = censor["val"] as! String
                                let status = censor["status"] as! Int
                                
                                let interiorCensorObject : interiorCensor = interiorCensor(description: desc, alarmStatus: status, value: val)
                               
                                self.censorArray.append(interiorCensorObject)
                                
                                
                            }
                            self.dismissDialog()
                            self.performSegue(withIdentifier: "todigitalinput", sender: nil)
                        }
                        
                        
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                }
                
            }
        }
        task.resume()

    }

    @IBAction func ipDevDetails(_ sender: Any) {
        
        ipDevArray.removeAll()
        self.showDialog()
        
        let session = URLSession.shared
        var urlComponent = URLComponents(string: "http://\(ipNumber)/goform/login")
        urlComponent?.queryItems = [URLQueryItem(name: "username", value: username),URLQueryItem(name: "password", value: password)]
        
        let loginUrl = urlComponent?.url
        
        let task = session.dataTask(with: loginUrl!) { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            }else{ if data != nil {
                
                do{
                let cookieResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                    
                    
                    DispatchQueue.main.async {
                        
                        if let cookie = cookieResponse["cookie"] as? String{
                            print(cookie)
                            self.secondIpDevCall(cookie: cookie, ipNumber: self.ipNumber)
                        }
                    }
                    
                }catch{
                    print(error.localizedDescription)
                }
                }
                
                
            }
        }
        task.resume()
        
    }
    
    func secondIpDevCall(cookie : String, ipNumber : String){
        
        let session = URLSession.shared
        
        let url = URL(string: "http://\(ipNumber)/json/get/appIpdev.json")!
        var request = URLRequest(url: url)
        request.addValue(cookie, forHTTPHeaderField: "cookie")

        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            }else{
                if data != nil {
                    
                    do{
                    let dataResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                        
                        DispatchQueue.main.sync {
                            guard let dataString = dataResponse["data"] as? Dictionary<String , Any> else {return}
                           
                            guard let censorDetailArray = dataString["ipdev"] as? [[String: Any]] else {return}
                            
                            
                            for censor in censorDetailArray{
                                
                                let desc = censor["desc"] as! String
                                let val = censor["val"] as! String
                                let ip = censor["ip"] as! String
                                
                                let ipDevObject : ipDev = ipDev(desc: desc, ip: ip, val: val)
                               
                                self.ipDevArray.append(ipDevObject)

                            }
                            self.dismissDialog()
                            self.performSegue(withIdentifier: "toIpDev", sender: nil)
                        }

                    }catch{
                        
                        print(error.localizedDescription)
                    }
                }
            }
        }
        task.resume()

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
               
    if segue.identifier == "toInterior"{
        
        let destinationVC = segue.destination as! InteriorCollectionController
        destinationVC.interiorCensorArray = self.censorArray
    }
    
    if segue.identifier == "toExterior"{
        
        let destinationVC = segue.destination as! ExteriorCollectionController
        destinationVC.interiorCensorArray = self.censorArray
    }
   
    if segue.identifier == "todigitalinput"{
        
        let destinationVC = segue.destination as! DigitalCollectionController
        destinationVC.interiorCensorArray = self.censorArray
    }
        
    if segue.identifier == "toIpDev"{
        
        let destinationVC = segue.destination as! IpDevCollectionController
        destinationVC.ipDevArray = self.ipDevArray
    }
        
        
    }
    
    @IBAction func webGoView(_ sender: Any) {
        
        performSegue(withIdentifier: "toWebView", sender: nil)
    }
    
}
    



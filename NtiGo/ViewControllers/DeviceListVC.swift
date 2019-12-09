//
//  DeviceListVC.swift
//  NtiGo
//
//  Created by Levent Özkan on 23.11.2019.
//  Copyright © 2019 Levent Özkan. All rights reserved.
//

import UIKit
import CoreData

class DeviceListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
 

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addDeviceButton: UIButton!
    
    var nameArray = [String]()
    var usernameArray = [String]()
    var ipArray = [String]()
    var passwordArray = [String]()
    var modelArray = [String]()
    var username = ""
    var password = ""
    var ipNumber = ""
    var unitName = ""
    var modelName = ""
    var uptime = ""
    var firmware = ""
    var selectedIpNumber = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
         getData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false

        addDeviceButton.layer.cornerRadius = 25.0
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name?(NSNotification.Name(rawValue: "newDeviceAdded")), object: nil)
 
           
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddDeviceVc" {
            
            let navigationBar = UIBarButtonItem()
            navigationBar.title = "Back"
            navigationItem.backBarButtonItem = navigationBar
        }
        
        if segue.identifier == "toDeviceDetailVC"{
            
            let destinationVC = segue.destination as! DeviceDetailVC
            

            destinationVC.selectedDeviceNameTxt = "Device Name:    \(self.unitName)"
            destinationVC.selectedDeviceFirmwareTxt = "Firmware:     \(self.firmware)"
            destinationVC.selectedDeviceModelTxt = "Model:   \(self.modelName)"
            destinationVC.selectedDeviceUptimeTxt = "Uptime:     \(self.uptime)"
            
            destinationVC.selectedDeviceOnlyNameTxt = self.unitName
            destinationVC.selectedDeviceonlyModelTxt = self.modelName
            destinationVC.selectedDeviceOnlyUptimeTxt = self.uptime
            destinationVC.selectedDeviceOnlyFirmwareTxt = self.firmware
            
            destinationVC.username = self.username
            destinationVC.password = self.password
            destinationVC.ipNumber = self.selectedIpNumber
            
          print("SEGUE GİRDİ!!!")
        }
    }
    

    @IBAction func addDevice(_ sender: Any) {
        
        performSegue(withIdentifier: "toAddDeviceVC", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
        
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "devicerow") as! DeviceListCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        
        let deviceNameString = "Device Name: \(nameArray[indexPath.row])"
        let ipNumberString = "Ip Number: \(ipArray[indexPath.row])"
        
        let mutableDeviceNameString = NSMutableAttributedString(string: deviceNameString)
        mutableDeviceNameString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemRed, range: NSRange.init(location: 0, length: 12))
        
        let mutableIpNumberString = NSMutableAttributedString(string: ipNumberString)
        mutableIpNumberString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemRed, range: NSRange.init(location: 0, length: 10))
        
        username = usernameArray[indexPath.row] as String
        password = passwordArray[indexPath.row] as String
        ipNumber = ipArray[indexPath.row] as String
        
        cell.deviceNameTxt.attributedText = mutableDeviceNameString
        cell.ipNumberTxt.attributedText = mutableIpNumberString
        cell.passwordTxt.text = "Password: \(passwordArray[indexPath.row])"
        cell.usernameTxt.text = "Username: \(usernameArray[indexPath.row])"
        cell.modelNameTxt.text = modelArray[indexPath.row]
        
        switch modelArray[indexPath.row] {
            
        case "NTI 2-D":
            cell.deviceImage.image = UIImage(named: "nti2dm")
            
        case "NTI 5-D":
            cell.deviceImage.image = UIImage(named: "nti5dm")
            
        case "NTI 16-D":
            cell.deviceImage.image = UIImage(named: "nti16dm")
            
        default:
            cell.deviceImage.image = UIImage(named: "nti2dm")
        }
        
       cell.actionBlock = {
        
                self.showDialog()
           
        self.selectedIpNumber = self.ipArray[indexPath.row]
        var urlComponents = URLComponents(string: "http://\(self.ipArray[indexPath.row])/goform/login")
               var queryItems = [URLQueryItem]()
        let usernameQueryItem = URLQueryItem(name: "username", value: self.username)
        let passwordQueryItem = URLQueryItem(name: "password", value: self.password)
               queryItems.append(usernameQueryItem)
               queryItems.append(passwordQueryItem)
               urlComponents!.queryItems = queryItems
               
               let loginUrl = urlComponents!.url!
               
               let session = URLSession.shared
               let task = session.dataTask(with: loginUrl) { (data, response, error) in
                   if error != nil {
                       
                    
                   }else{
                       
                       if data != nil {
                           do{
                               let cookieResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String , Any>
                               
                               DispatchQueue.main.async {
                                   
                                   if let cookie = cookieResponse["cookie"] as? String{
                                       print(cookie)
                                    self.secondCall(cookie: cookie, ipNumber: self.ipArray[indexPath.row])
                                   }
                               }
                               
                               
                           }catch{
                               print(error.localizedDescription)
                           }
                           
                       }
                       
                   }
               }
               
               task.resume()}
        
    
        
        return cell
     }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{

            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Devices")
            let ipString = ipArray[indexPath.row]
            request.predicate = NSPredicate(format: "ipNumber=%@", ipString)
            
            do{
            let results = try context.fetch(request)
                if results.count > 0{
                    
                    for result in results as! [NSManagedObject]{
                                       
                        if let ip = result.value(forKey: "ipNumber") as? String{
                            
                            context.delete(result)
                            nameArray.remove(at: indexPath.row)
                            ipArray.remove(at: indexPath.row)
                            modelArray.remove(at: indexPath.row)
                            passwordArray.remove(at: indexPath.row)
                            usernameArray.remove(at: indexPath.row)
                                       
                            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
                            self.tableView.reloadData()
                        }
                    
                        do{
                            try context.save()
                        }catch{
                            print(error)
                        }
                    }
                }
                
               
                
            }catch{
                print(error)
            }
         
        }
    }
    
   
   
    
    @objc func getData(){
        
        nameArray.removeAll()
        usernameArray.removeAll()
        ipArray.removeAll()
        passwordArray.removeAll()
        modelArray.removeAll()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Devices")
        request.returnsObjectsAsFaults = false
        
        do{
        let results =  try context.fetch(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    let name = result.value(forKey: "deviceName")
                    let username = result.value(forKey: "username")
                    let password = result.value(forKey: "password")
                    let ipNumber = result.value(forKey: "ipNumber")
                    let model = result.value(forKey: "deviceModel")
                    
                    nameArray.append(name as! String)
                    usernameArray.append(username as! String)
                    ipArray.append(ipNumber as! String)
                    passwordArray.append(password as! String)
                    modelArray.append(model as! String)
                    tableView.reloadData()
                }
            }
        }catch{
            print(error.localizedDescription)
        }
        
        
    }
    
    func secondCall(cookie : String , ipNumber : String){
        
        let urlSessionTwo = URLSession.shared
        let url = URL(string: "http://\(ipNumber)/json/get/appDevice.json")!
        var request = URLRequest(url: url)
        request.addValue(cookie, forHTTPHeaderField: "cookie")
        
        let taskTwo = urlSessionTwo.dataTask(with: request) { (data, response, error) in
            if error != nil {
                
                
            }else{
                
                do{let enviromuxResponse =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                    
                    DispatchQueue.main.async {
                        let dataEnviromux = enviromuxResponse["data"] as! Dictionary<String , Any>
                        let deviceEnviromux = dataEnviromux["device"] as! Dictionary<String , Any>
                        self.unitName = deviceEnviromux["unit"] as! String
                        self.modelName = deviceEnviromux["model"] as! String
                        self.uptime = deviceEnviromux["uptime"] as! String
                        self.firmware = deviceEnviromux["firmware"] as! String
                        
                        print(self.unitName)
                        print(self.firmware)
                        self.dismissDialog()
                        self.performSegue(withIdentifier: "toDeviceDetailVC", sender: nil)
                        
                    }
                    
                }catch{
                     print(error.localizedDescription)
                }
                
            }
        }
        taskTwo.resume()
        
        
        
    }
 
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
           
        return .darkContent
           
       }

     static func navBackgroundFunc(kontrol : String) -> UINavigationBarAppearance{
       
        var appearance : UINavigationBarAppearance? = UINavigationBarAppearance()
        if kontrol == "1"{
            appearance!.backgroundImage = UIImage(named: "drduz1")
                  
            appearance!.largeTitleTextAttributes = [.font : UIFont(name: "Neo Sans Pro", size: 30), .foregroundColor : UIColor.white ]
            
            return appearance!
            
        }else{
            
            appearance?.backgroundImage = nil
            appearance?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            appearance!.largeTitleTextAttributes = [.font : UIFont(name: "Neo Sans Pro", size: 30), .foregroundColor : UIColor.white ]
            
            return appearance!
            
            
        }
        
        
    }
     
    
}

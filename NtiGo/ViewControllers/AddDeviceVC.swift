//
//  AddDeviceVC.swift
//  NtiGo
//
//  Created by Levent Özkan on 24.11.2019.
//  Copyright © 2019 Levent Özkan. All rights reserved.
//

import UIKit
import CoreData

class AddDeviceVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var deviceNameEditText: UITextField!
    
    @IBOutlet weak var ipNumberEditText: UITextField!
    
    @IBOutlet weak var usernameEditText: UITextField!
    
    @IBOutlet weak var passwordEditText: UITextField!
    
    @IBOutlet weak var addDeviceButton: UIButton!
    
    @IBOutlet weak var modelPickerView: UIPickerView!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    var pickerList = ["NTI 2-D", "NTI 5-D", "NTI 16-D"]
    
    
    var deviceModel = ""
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
           
           return .lightContent
           
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        print("GİRDİ Ddiididi")
        
        let appearance : UINavigationBarAppearance = DeviceListVC.navBackgroundFunc(kontrol: "0")
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        deviceNameEditText.delegate = self
        usernameEditText.delegate = self
        passwordEditText.delegate = self
        ipNumberEditText.delegate = self
        
        addDeviceButton.layer.cornerRadius = 25.0
        modelPickerView.delegate = self
        modelPickerView.dataSource = self
        
        modelPickerView.layer.cornerRadius = 25.0
        
        
       
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
       
       
    }
    
    
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
        
    }
    

    @IBAction func addDevicetodatabase(_ sender: Any) {
        
        if deviceNameEditText.text == "" && usernameEditText.text == "" && passwordEditText.text == "" && ipNumberEditText.text == "" && deviceModel == ""
        {
            
            let alert = UIAlertController(title: "Error", message: "Please fill in the blanks.", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
            
        }else{
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let newDevice = NSEntityDescription.insertNewObject(forEntityName: "Devices", into: context)
        newDevice.setValue(deviceNameEditText.text, forKey: "deviceName")
        newDevice.setValue(ipNumberEditText.text, forKey: "ipNumber")
        newDevice.setValue(usernameEditText.text, forKey: "username")
        newDevice.setValue(passwordEditText.text, forKey: "password")
        newDevice.setValue(String(deviceModel), forKey: "deviceModel")
        
        do{
           try context.save()
            NotificationCenter.default.post(name: NSNotification.Name("newDeviceAdded"), object: nil)
            self.navigationController?.popViewController(animated: true)
            
        }catch {
            print(error.localizedDescription)
        }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch row {
        case 0:
             deviceModel = pickerList[0]
            
        case 1:
             deviceModel = pickerList[1]
        case 2:
             deviceModel = pickerList[2]
        default:
            deviceModel = ""
        }
    }
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 1:
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        case 2:
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        case 3:
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        case 4:
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        default:
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       switch textField.tag {
        case 1:
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        case 2:
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        case 3:
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        case 4:
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        default:
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    

}

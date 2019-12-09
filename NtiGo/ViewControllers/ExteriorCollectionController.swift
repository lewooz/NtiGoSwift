//
//  ExteriorCollectionController.swift
//  NtiGo
//
//  Created by Levent Özkan on 6.12.2019.
//  Copyright © 2019 Levent Özkan. All rights reserved.
//

import UIKit



class ExteriorCollectionController: UICollectionViewController, UINavigationBarDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBOutlet var exteriorCollectionView: UICollectionView!
    
    let bar = UINavigationBar()
    let appearance = UINavigationBarAppearance()
   
    var popView : UIView? = nil
    
    var interiorCensorArray = [interiorCensor]()
    
    var imaginaryView : UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        exteriorCollectionView.delegate = self
        exteriorCollectionView.dataSource = self
        
        let navItem = createNavItem()
        createBackBarButton(forNavigationItem: navItem)
        createNavBar(item: navItem)
        
        let imageView : UIImageView = {
            let view = UIImageView()
            view.image = UIImage(named: "mainbackground")
            view.contentMode = .scaleAspectFill
            return view
        }()
        exteriorCollectionView.backgroundView = imageView
        
        imaginaryView = UIView()
        self.imaginaryView!.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.width)
        self.imaginaryView!.isHidden = true
        self.imaginaryView?.backgroundColor = #colorLiteral(red: 0.5368879746, green: 0.5368879746, blue: 0.5368879746, alpha: 1)
        
        view.addSubview(imaginaryView!)
        self.imaginaryView?.translatesAutoresizingMaskIntoConstraints =  false
        
        self.imaginaryView!.topAnchor.constraint(equalTo: bar.bottomAnchor, constant: 0).isActive = true
        self.imaginaryView!.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        self.imaginaryView!.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        self.imaginaryView!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        exteriorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        exteriorCollectionView.topAnchor.constraint(equalTo: bar.bottomAnchor, constant: 0).isActive = true
        exteriorCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        exteriorCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        exteriorCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        let gesgureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewtap))
        imaginaryView!.addGestureRecognizer(gesgureRecognizer)

        /*if let flowLayout = exteriorCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            
        flowLayout.itemSize = CGSize(width: view.frame.width/2.3, height: 150)
            
      
        }*/
      
    }
    
    @objc func viewtap(){

            
        popView?.removeFromSuperview()
        popView = nil
        self.view.alpha = 1
           
        imaginaryView?.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
      
        navigationController?.isNavigationBarHidden = true
        
        
    }
  

        

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return interiorCensorArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interiorcell", for: indexPath) as! InteriorCell
        
       
        cell.descLabel.text = interiorCensorArray[indexPath.row].description
        
        
        if interiorCensorArray[indexPath.row].alarmStatus == 1{
        cell.alarmLabel.text = "NO ALARM"
        cell.backgroundColor = UIColor(red:0.17, green:0.53, blue:0.06, alpha:1.0)
        }else{
        cell.alarmLabel.text = "ALARM!!!"
        cell.backgroundColor = .red
        }
        
        cell.valLabel.text = interiorCensorArray[indexPath.row].value
      
       
        return cell
    }
    
   

    func createNavItem() -> UINavigationItem{
        
        let item = UINavigationItem()
        item.title = "EXTERIOR CENSORS"
        
        item.largeTitleDisplayMode = .always
        
        return item
    }
    
    func createNavBar(item : UINavigationItem){

        let item = item

       
        bar.prefersLargeTitles = true
        bar.isTranslucent = false

        appearance.backgroundImage = UIImage(named: "exteriorHeader")
        appearance.largeTitleTextAttributes = [.font : UIFont(name: "Neo Sans Pro", size: 34)!, .foregroundColor : UIColor.white ]
       
        
        bar.standardAppearance = appearance
        bar.compactAppearance = appearance
        bar.scrollEdgeAppearance = appearance
        
        view.addSubview(bar)
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        bar.items = [item]
        
        bar.delegate = self
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    
    func createBackBarButton(forNavigationItem navigationItem:UINavigationItem){
        let backButtonImage = UIImage(named: "siyahback")
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: backButtonImage!.size.width, height: backButtonImage!.size.height))
        backButton.setImage(backButtonImage!, for: .normal)
        backButton.addTarget(self, action: #selector(InteriorCollectionController.backBarButtonTapped), for: UIControl.Event.touchUpInside)
        let backBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItems = [backBarButton]
    }
    
    @ objc func backBarButtonTapped(){
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         popView = createPopUpView(descTxt: interiorCensorArray[indexPath.row].description, status: interiorCensorArray[indexPath.row].alarmStatus, valueTxt: interiorCensorArray[indexPath.row].value)
        self.imaginaryView!.alpha = 0.5
        popView?.alpha = 1
        self.view.addSubview(popView!)
        self.imaginaryView?.isHidden = false
    
    }
    
    func createPopUpView(descTxt : String , status : Int , valueTxt : String) -> UIView{
        
        
        let popUpView = UIView()
        popUpView.isOpaque = false
        popUpView.backgroundColor = UIColor(red:0.17, green:0.53, blue:0.06, alpha:1.0)
        popUpView.layer.backgroundColor = UIColor(red:0.17, green:0.53, blue:0.06, alpha:1.0).cgColor
        
        
        self.view.addSubview(popUpView)
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        popUpView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        popUpView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        popUpView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        popUpView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3).isActive = true
        
     

        let popDescLabel : UILabel = {
            let view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.textAlignment = .center
            view.font = UIFont.init(name: "Neo Sans Pro", size: 25)
            view.textColor = .black
            view.text = descTxt
            view.numberOfLines = 2
            
            return view
        }()
        let popStatusLabel : UILabel = {
            let view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.textAlignment = .center
            view.font = UIFont.init(name: "Neo Sans Pro", size: 30)
            view.textColor = .black
            if status == 1{
                view.text = "NO ALARM"
            }else{
                view.text = "ALARM!!!"
            }
            
            return view
        }()
        let popAlarmLabel : UILabel = {
            let view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.textAlignment = .center
            view.font = UIFont.init(name: "Neo Sans Pro", size: 45)
            view.textColor = .black
            view.text = valueTxt
            
            return view
        }()

        let stackView = UIStackView(arrangedSubviews: [popDescLabel,popStatusLabel,popAlarmLabel])
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 15
        
        popUpView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: popUpView.centerYAnchor).isActive = true

        
        return popUpView
    }

}

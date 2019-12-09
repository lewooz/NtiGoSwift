//
//  InteriorCell.swift
//  NtiGo
//
//  Created by Levent Özkan on 1.12.2019.
//  Copyright © 2019 Levent Özkan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "interiorcell"

class InteriorCell: UICollectionViewCell {
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var valLabel: UILabel!
    
 
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
        
       
        
       }
}

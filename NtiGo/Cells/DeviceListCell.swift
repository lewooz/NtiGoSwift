//
//  DeviceListCell.swift
//  NtiGo
//
//  Created by Levent Özkan on 23.11.2019.
//  Copyright © 2019 Levent Özkan. All rights reserved.
//

import UIKit

class DeviceListCell: UITableViewCell {

    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var ipNumberTxt: UILabel!
    @IBOutlet weak var deviceNameTxt: UILabel!
    @IBOutlet weak var passwordTxt: UILabel!
    @IBOutlet weak var usernameTxt: UILabel!
    @IBOutlet weak var modelNameTxt: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    
    var actionBlock : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    @IBAction func sendToDetail(_ sender: Any) {
    
        actionBlock?()
    }
}

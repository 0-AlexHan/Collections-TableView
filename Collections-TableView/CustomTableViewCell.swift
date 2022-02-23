//
//  CustomTableViewCell.swift
//  Collections-TableView
//
//  Created by Alex Han on 15.07.2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet private weak var deviceImageView: UIImageView!
    @IBOutlet private weak var deviceTitle: UILabel!
    @IBOutlet private weak var deviceInfo: UILabel!
    
    
    func setDevice(device: DevicesData) {
        deviceImageView.image = device.image
        deviceTitle.text = device.title
        let info =  device.info ?? "No info"
        deviceInfo.text = info
    }
}

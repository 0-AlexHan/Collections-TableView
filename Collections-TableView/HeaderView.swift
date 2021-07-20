//
//  HeaderView.swift
//  Collections-TableView
//
//  Created by Alex Han on 19.07.2021.
//

import UIKit

protocol HeaderViewDelegate {
    func add(item device: DevicesData?)
}

class HeaderView: UITableViewHeaderFooterView {
    var delegate: HeaderViewDelegate?
    var deviceType: DevicesData?
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var view: UIView!
    
    @IBAction func addItem(_ sender: Any) {
        addButton.tag = 0
        self.delegate?.add(item: self.deviceType)
    }
    
}

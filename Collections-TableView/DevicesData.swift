//
//  AppleDevices.swift
//  Collections-TableView
//
//  Created by Alex Han on 13.07.2021.
//

import UIKit



protocol DevicesData {
    var title: String { set get }
    var image: UIImage { set get }
    var info: String? { set get }
}

struct iPad: DevicesData {
    var title: String
    var image: UIImage
    var info: String?
    
    static func getAlliPads() -> [iPad] {
        let iPadsDevices: [iPad] = Device.allPads.map { device -> iPad in
            let stringPPI = "PPI: ", diagonal = "Diagonal: "
            let unknownDeviceImage: UIImage = #imageLiteral(resourceName: "Unknown")
            let iPads = iPad(title: device.description,
                             image: UIImage(named: device.rawValue.lowercased()) ?? unknownDeviceImage,
                             info: stringPPI + String(device.ppi ?? 0) + ", " + diagonal + String(device.diagonal))
            return iPads            
        }
        return iPadsDevices
    }
}

struct iPhone: DevicesData {
    var title: String
    var image: UIImage
    var info: String?
    
    static func getAlliPhones() -> [iPhone] {
        let iPhoneDevices: [iPhone] = Device.allPhones.map { device -> iPhone in
            let stringPPI = "PPI: ", diagonal = "Diagonal: "
            let unknownDeviceImage: UIImage = #imageLiteral(resourceName: "Unknown")
            let iPhone = iPhone(title: device.description,
                                image: UIImage(named: device.rawValue.lowercased()) ?? unknownDeviceImage,
                                info: stringPPI + String(device.ppi ?? 0) + ", " + diagonal + String(device.diagonal))
            return iPhone
        }
        return iPhoneDevices
    }
}

struct Expandable {
    var isExpanded: Bool
    var devicesArray: [DevicesData]
}








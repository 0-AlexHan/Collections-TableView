//
//  DetailsViewController.swift
//  Collections-TableView
//
//  Created by Alex Han on 16.07.2021.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var deviceImage: UIImageView!
    
    @IBOutlet private weak var coreView: UIView!
    private  let textView = UITextView()
    private var deviceDetails: DevicesData?
    var passedDevice: DevicesData?
    var didPassToList: ((_ device: DevicesData?) -> Void)?
    var devicesType: DevicesData?
    private var defaultDevice: DevicesData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let defaultImage = #imageLiteral(resourceName: "Unknown")
        deviceImage.image = defaultImage
        defaultDevice = devicesType
        defaultDevice?.image = defaultImage
        defaultDevice?.info = "Type device info"
        defaultDevice?.title =  devicesType?.title.components(separatedBy: " ").first ?? "Default Name"
        if let device = passedDevice {
            setUpDetails(device: device)
        } else {
            if let savedDeviceToGetType = defaultDevice {
                
                setUpDetails(device: savedDeviceToGetType)
            }
        }
        
        textView.delegate = self
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Add Device Image",
                                                              style: .plain,
                                                              target: self,
                                                              action: #selector(addDidTap)),
                                              UIBarButtonItem(barButtonSystemItem: .save,
                                                              target: self,
                                                              action: #selector(saveDidTap))]
    }
    
    @objc func addDidTap() {
        ImagePickerManager().pickImage(self) { image in
            self.deviceImage.image = image
        }
    }
    
    @objc func saveDidTap() {
        if var savedDeviceToGetType = defaultDevice {
            
            savedDeviceToGetType.image = deviceImage.image!
            savedDeviceToGetType.info = textView.text
            didPassToList?(savedDeviceToGetType)
        } else {
            passedDevice?.image = deviceImage.image!
            passedDevice?.info = textView.text
            didPassToList?(passedDevice)
        }
        
    }
}

extension DetailsViewController: UITextViewDelegate {
    
    private func setUpDetails(device: DevicesData) {
        deviceImage.image = device.image
        coreView.backgroundColor = .lightGray
        let modelLabel = UILabel(frame: CGRect(x: 5, y: 0,
                                               width: 100,
                                               height: 35))
        modelLabel.text = "Model: "
        modelLabel.font = UIFont.boldSystemFont(ofSize: 16)
        coreView.addSubview(modelLabel)
        let textLabel = UILabel(frame: CGRect(x: 5, y: 30,
                                              width: 200,
                                              height: 35))
        textLabel.text = device.title
        textLabel.font = UIFont.systemFont(ofSize: 14)
        coreView.addSubview(textLabel)
        let spacingLabel = UILabel(frame: CGRect(x: 0, y: 45,
                                                 width: coreView.frame.width,
                                                 height: 35))
        spacingLabel.text = "___________________________"
        coreView.addSubview(spacingLabel)
        let infoLabel = UILabel(frame: CGRect(x: 5, y: 70,
                                              width: 100,
                                              height: 35))
        infoLabel.text = "Info: "
        infoLabel.font = UIFont.boldSystemFont(ofSize: 16)
        coreView.addSubview(infoLabel)
        textView.frame = CGRect(x: 0, y: 100,
                                width: coreView.frame.width,
                                height: coreView.frame.height - 110)
        textView.isEditable = true
        textView.isSelectable = true
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = .lightGray
        textView.text = device.info
        coreView.addSubview(textView)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        
        return true
    }
}

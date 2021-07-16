//
//  ViewController.swift
//  Collections-TableView
//
//  Created by Alex Han on 13.07.2021.
//

import UIKit

class FirstTableViewController: UITableViewController {

    private var allDevices = [DevicesData]()
    private let cellID = String(describing: CustomTableViewCell.self)
    private var passedDeviceData: DevicesData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Apple Devices"
        tableView.dataSource = self
        tableView.delegate = self
        allDevices = iPad.getAlliPads() + iPhone.getAlliPhones()
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
}

extension FirstTableViewController {
        
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Delete") { action, view, completion in
            self.allDevices.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        action.backgroundColor = .red
        
        return action
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = allDevices[indexPath.row]
        let detailsViewControllerName = String(describing: DetailsViewController.self)
        let detailsViewController = DetailsViewController(nibName: detailsViewControllerName, bundle: nil)
        detailsViewController.passedDevice = device
        
//        detailsViewController.didPassToList = { passDevice in
//        тут был возврат, но его съели волки
//        }
        
        self.navigationController?.pushViewController(detailsViewController, animated: true)        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDevices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let customCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CustomTableViewCell else {
            return CustomTableViewCell()
        }
        let device = allDevices[indexPath.row]
        customCell.setDevice(device: device)
        
        return customCell
    }
    
   
    
    
    
    
}


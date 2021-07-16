//
//  SecondTableViewController.swift
//  Collections-TableView
//
//  Created by Alex Han on 13.07.2021.
//

import UIKit

class SecondTableViewController: UITableViewController {
    
    private var allDevices = [Expandable]()
    private let cellID = String(describing: CustomTableViewCell.self)
    
    private var expandableiPads: [Expandable] = [Expandable(isExpanded: false,
                                                         devicesArray: iPad.getAlliPads())]
    private var expandableiPhones: [Expandable] = [Expandable(isExpanded: false,
                                                          devicesArray: iPhone.getAlliPhones())]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self        
        allDevices = expandableiPads + expandableiPhones
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
}


extension SecondTableViewController {
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)

        return UISwipeActionsConfiguration(actions: [delete])
    }

    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Delete") { action, view, completion in
            self.allDevices[indexPath.section].devicesArray.remove(at: indexPath.row)
            if self.allDevices[indexPath.section].devicesArray.count > 0 {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                self.allDevices.remove(at: indexPath.section)
                self.tableView.deleteSections([indexPath.section], with: .automatic)
            }
        }
        action.backgroundColor = .red

        return action
    }
    
    @objc func handleExpand(button: UIButton) {
        let section = button.tag
        var indexPaths = [IndexPath]()
        for row in allDevices[section].devicesArray.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        let isExpanded = allDevices[section].isExpanded
        allDevices[section].isExpanded = !isExpanded
        if isExpanded {
            tableView.insertRows(at: indexPaths, with: .fade)
            
        } else {
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let expandableSection = UIButton()
        expandableSection.setTitleColor(.black, for: .normal)
        expandableSection.backgroundColor = .lightGray
        expandableSection.addTarget(self, action: #selector(handleExpand), for: .touchUpInside)
        expandableSection.tag = section
        guard let first = allDevices[section].devicesArray.first else {
            expandableSection.setTitle("An error occurred when attempting to load title", for: .normal)
            return expandableSection
        }
        expandableSection.setTitle(String(describing: type(of: first).self), for: .normal)
        
        return expandableSection
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = allDevices[indexPath.section].devicesArray[indexPath.row]
        let detailsViewControllerName = String(describing: DetailsViewController.self)
        let detailsViewController = DetailsViewController(nibName: detailsViewControllerName, bundle: nil)
        detailsViewController.passedDevice = device
        
//        detailsViewController.didPassToList = { passDevice in
//        тут был возврат, но его съели волки
//        }
        
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allDevices.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !allDevices[section].isExpanded {
            return allDevices[section].devicesArray.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {       
        guard let customCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        let device = allDevices[indexPath.section].devicesArray[indexPath.row]
        customCell.setDevice(device: device)
        
        return customCell
    }
}

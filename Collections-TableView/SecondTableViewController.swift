//
//  SecondTableViewController.swift
//  Collections-TableView
//
//  Created by Alex Han on 13.07.2021.
//

import UIKit

class SecondTableViewController: UITableViewController {
    
    private var allDevices = [Expandable]()
    private var expandableiPads: [Expandable] = [Expandable(isExpanded: false,
                                                            devicesArray: iPad.getAlliPads())]
    private var expandableiPhones: [Expandable] = [Expandable(isExpanded: false,
                                                              devicesArray: iPhone.getAlliPhones())]
    private let cellID = String(describing: CustomTableViewCell.self)
    private let headerID = String(describing: HeaderView.self)
    private var savedDeviceToGetType: DevicesData?
    private var addNewDeviceToSection: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allDevices = expandableiPads + expandableiPhones
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        let headerNib = UINib(nibName: headerID, bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: headerID)
    }
}


extension SecondTableViewController: HeaderViewDelegate {
    
    func add(item device: DevicesData?) {
        let detailsViewControllerName = String(describing: DetailsViewController.self)
        let detailsViewController = DetailsViewController(nibName: detailsViewControllerName, bundle: nil)
        detailsViewController.devicesType = savedDeviceToGetType
        detailsViewController.didPassToList = { passNewDeviceToList in
            guard let newDevice = passNewDeviceToList else {
                return
            }
            self.allDevices[self.addNewDeviceToSection].devicesArray.append( newDevice)
            
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
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
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as? HeaderView else {
            let errorHeader = HeaderView()
            return errorHeader
        }
        headerView.view.backgroundColor = .lightGray
        headerView.delegate = self
        let expandableSection = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        
        expandableSection.backgroundColor = .lightGray
        expandableSection.setTitleColor(.black, for: .normal)

        expandableSection.addTarget(self, action: #selector(handleExpand), for: .touchUpInside)
        expandableSection.tag = section
        
        guard let first = allDevices[section].devicesArray.first else {
            expandableSection.setTitle("An error occurred when attempting to load title", for: .normal)
            return expandableSection
        }
        savedDeviceToGetType = first
        addNewDeviceToSection = section
        
        expandableSection.setTitle(String(describing: type(of: first).self), for: .normal)

       
        headerView.view.addSubview(expandableSection)

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = allDevices[indexPath.section].devicesArray[indexPath.row]
        let detailsViewControllerName = String(describing: DetailsViewController.self)
        let detailsViewController = DetailsViewController(nibName: detailsViewControllerName, bundle: nil)
        detailsViewController.passedDevice = device

        detailsViewController.didPassToList = { passDevice in
            guard let updateDevice = passDevice else {
                return
            }
            self.allDevices[indexPath.section].devicesArray[indexPath.row] = updateDevice
            tableView.reloadData()
        }

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


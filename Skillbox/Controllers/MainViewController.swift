//
//  MainViewController.swift
//  Skillbox
//
//  Created by David Dreval on 29.02.2020.
//  Copyright © 2020 Snaappy. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    enum Controllers: String {
        case textFields = "Text Fields"
        case realm = "Realm"
        case coreData = "Core Data"
    }
    
    let controllers = [Controllers.textFields, Controllers.realm, Controllers.coreData]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = controllers[indexPath.row].rawValue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch controllers[indexPath.row] {
        case .textFields:
            let controller = TextFieldsViewController()
            navigationController?.pushViewController(controller, animated: true)
            break
        case .realm:
            let controller = TodoViewController()
            controller.dataSource = RealmDataSource()
            navigationController?.pushViewController(controller, animated: true)
            break
        case .coreData:
            let controller = TodoViewController()
            controller.dataSource = CoreDataDataSource()
            navigationController?.pushViewController(controller, animated: true)
            break
        }
    }

}

//
//  TodoViewController.swift
//  Skillbox
//
//  Created by David Dreval on 01.03.2020.
//  Copyright © 2020 Snaappy. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    var dataSource: DataSource?
    var list: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = dataSource?.getTasks() ?? []
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "taskCell")
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        tableView.tableFooterView = UIView()
    }
    
    @objc func insertNewObject(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter Task Name", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = "Task Name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [weak self] alert -> Void in
            if let name = alertController.textFields?.first?.text {
                let task = Task(taskName: name, created: Date(), identifier: NSUUID().uuidString, completed: false)
                self?.dataSource?.save(task: task, completed: { [weak self] in
                    self?.update()
                })
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action : UIAlertAction) -> Void in })

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    private func update() {
        list = dataSource?.getTasks() ?? []
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TodoTableViewCell
        cell.textLabel?.text = list[indexPath.row].taskName
        cell.accessoryType = list[indexPath.row].completed ? .checkmark : .none
        cell.detailTextLabel?.text = list[indexPath.row].completed ? "Task is completed" : "Task is not completed"
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = list[indexPath.row]
            dataSource?.remove(task: task, completed: { [weak self] in
                self?.list = self?.dataSource?.getTasks() ?? []
                self?.tableView.deleteRows(at: [indexPath], with: .fade)
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = list[indexPath.row]
        task.completed = !task.completed
        list[indexPath.row] = task
        dataSource?.update(task: task, completed: { [weak self] in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        })
    }
}

class TodoTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

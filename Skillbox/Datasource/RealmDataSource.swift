//
//  RealmDataSource.swift
//  Skillbox
//
//  Created by David Dreval on 01.03.2020.
//  Copyright © 2020 Snaappy. All rights reserved.
//

import Foundation
import RealmSwift

class RealmTask: Object {
    @objc dynamic var name = ""
    @objc dynamic var timestamp = Date()
    @objc dynamic var id = ""
    @objc dynamic var completed = false
    @objc dynamic var subObject = SubObject()
}

class SubObject: Object {
    @objc dynamic var subName = ""
    @objc dynamic var anyDate = Date()
}

class RealmDataSource: DataSource {
    private let realm = try! Realm()
    
    func getTasks() -> [Task] {
        var tasks: [Task] = []
        realm.objects(RealmTask.self).forEach { (realmTask) in
            let task = Task(taskName: realmTask.name, created: realmTask.timestamp, identifier: realmTask.id, completed: realmTask.completed)
            tasks.append(task)
        }
        return tasks
    }
    
    func save(task: Task, completed: @escaping () -> ()) {
        try? realm.write {
            let realmTask = RealmTask()
            realmTask.name = task.taskName
            realmTask.timestamp = task.created
            realmTask.id = task.identifier
            realmTask.completed = task.completed
            realm.add(realmTask)
        }
        completed()
    }
    
    func remove(task: Task, completed: @escaping () -> ()) {
        let realmTaskToDelete = realm.objects(RealmTask.self).filter { $0.id == task.identifier }.first
        if let realmTask = realmTaskToDelete {
            try? realm.write {
                realm.delete(realmTask)
            }
        }
        completed()
    }
    
    func update(task: Task, completed: @escaping () -> ()) {
        let realmTaskToDelete = realm.objects(RealmTask.self).filter { $0.id == task.identifier }.first
        if let realmTask = realmTaskToDelete {
            try? realm.write {
                realmTask.completed = task.completed
            }
        }
        completed()
    }
}

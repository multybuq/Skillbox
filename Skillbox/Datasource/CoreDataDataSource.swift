//
//  CoreDataDataSource.swift
//  Skillbox
//
//  Created by David Dreval on 01.03.2020.
//  Copyright © 2020 Snaappy. All rights reserved.
//

import UIKit
import CoreData

class CoreDataDataSource: DataSource {
    private let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    func getTasks() -> [Task] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        let fetchResult = try? container?.viewContext.fetch(fetchRequest) as? [TaskEntity]
        
        var tasks: [Task] = []
        fetchResult?.forEach { (coredataTask) in
            if let name = coredataTask.name, let timestamp = coredataTask.timestamp, let id = coredataTask.id {
                let task = Task(taskName: name, created: timestamp, identifier: id, completed: coredataTask.completed)
                tasks.append(task)
            }
        }
        return tasks
    }
    
    func save(task: Task, completed: @escaping () -> ()) {
        container?.performBackgroundTask({ (context) in
            let newTask = TaskEntity(context: context)
            newTask.name = task.taskName
            newTask.timestamp = task.created
            newTask.id = task.identifier
            newTask.completed = task.completed
            try? context.save()
            DispatchQueue.main.async {
                completed()
            }
        })
    }
    
    func remove(task: Task, completed: @escaping () -> ()) {
        container?.performBackgroundTask({ (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
            fetchRequest.predicate = NSPredicate(format: "id = %@", task.identifier)
            let fetchResult = try? context.fetch(fetchRequest) as? [TaskEntity]
            fetchResult?.forEach({ (coredataTask) in
                context.delete(coredataTask)
            })
            try? context.save()
            DispatchQueue.main.async {
                completed()
            }
        })
    }
    
    func update(task: Task, completed: @escaping () -> ()) {
        container?.performBackgroundTask({ (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
            fetchRequest.predicate = NSPredicate(format: "id = %@", task.identifier)
            let fetchResult = try? context.fetch(fetchRequest) as? [TaskEntity]
            fetchResult?.forEach({ (coredataTask) in
                coredataTask.completed = task.completed
            })
            try? context.save()
            DispatchQueue.main.async {
                completed()
            }
        })
    }
}

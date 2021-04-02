//
//  DataSource.swift
//  Skillbox
//
//  Created by David Dreval on 01.03.2020.
//  Copyright © 2020 Snaappy. All rights reserved.
//

import Foundation

protocol DataSource {
    func getTasks() -> [Task]
    func save(task: Task, completed: @escaping () -> ())
    func remove(task: Task, completed: @escaping () -> ())
    func update(task: Task, completed: @escaping () -> ())
}

struct Task {
    let taskName: String
    let created: Date
    let identifier: String
    var completed: Bool
}

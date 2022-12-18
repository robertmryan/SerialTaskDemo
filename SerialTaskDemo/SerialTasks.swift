//
//  SerialTasks.swift
//  SerialTaskDemo
//
//  Created by Robert Ryan on 12/18/22.
//

import Foundation

actor SerialTasks<Success> {
    private var previousTask: Task<Success, Error>?

    func add(block: @Sendable @escaping () async throws -> Success) async throws -> Success {
        let task = Task { [previousTask] in
            let _ = await previousTask?.result
            return try await block()
        }
        previousTask = task
        return try await task.value
    }
}

//
//  ViewModel.swift
//  SerialTaskDemo
//
//  Created by Robert Ryan on 12/18/22.
//

import Foundation
import os.log

// The `pointsOfInterest` log can be observed with “Points of Interest” tool in “Instruments”

private let poi = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: .pointsOfInterest)

@MainActor
class ViewModel: ObservableObject {
    private let serialTasks = SerialTasks<String>()

    @Published var string: String = ""

    func makeRequest() async throws {
        // “Points of Interest” Ⓢ signpost when user initiates a request

        os_signpost(.event, log: poi, name: #function)

        string = try await serialTasks.add {
            // “Points of Interest” interval for duration of the request

            let id = OSSignpostID(log: poi)
            os_signpost(.begin, log: poi, name: #function, signpostID: id)
            defer { os_signpost(.end, log: poi, name: #function, signpostID: id) }

            // some asynchronous task (in this case, making network request, parsing
            // response, and updating view model property
            
            let url = URL(string: "https://httpbin.org/uuid")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let object = try JSONDecoder().decode(UUIDResponse.self, from: data)
            return object.uuid
        }
    }
}

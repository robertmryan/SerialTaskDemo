//
//  ContentView.swift
//  SerialTaskDemo
//
//  Created by Robert Ryan on 12/18/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()

    var body: some View {
        VStack {
            Text(viewModel.string)
            Button("`await` prior `Task`") {
                Task {
                    try await viewModel.makeRequest()
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  SampleApp.swift
//  Sample
//
//  Created by Mauricio Tremea Zaquia on 22/07/2025.
//

import SwiftUI

extension String: @retroactive LocalizedError {
    public var errorDescription: String? { self }
}

@main
struct SampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

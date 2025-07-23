//
//  Binding+Extensions.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 23/07/2025.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

//
//  FormulaireMetadata.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 22/07/2025.
//

import SwiftUI

typealias FormFocus = FocusState<String?>.Binding

@Observable
public final class FormulaireChecker<F: Formulaire> {
    private var errors: [F.Fields.Cases: Error] = [:]

    @ObservationIgnored
    var nextFocus: F.Fields.Cases?

    public func addError(_ error: Error, field: F.Fields.Cases) {
        errors[field] = error
    }

    public func focus(on field: F.Fields.Cases) {
        nextFocus = field
    }

    func getNextFocus() -> F.Fields.Cases? {
        defer {
            nextFocus = nil
        }
        
        return nextFocus
    }

    func clearAllErrors() {
        errors = [:]
    }

    func hasErrors() -> Bool {
        !errors.values.compactMap(\.self).isEmpty
    }

    func error(for field: F.Fields.Cases) -> Error? {
        errors[field]
    }
}

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
    private var errors: [PartialKeyPath<F>: Error] = [:]

    @ObservationIgnored
    var nextFocus: String?

    public func addError(_ error: Error, field: PartialKeyPath<F>) {
        errors[field] = error
    }

    public func focus(on field: PartialKeyPath<F>) {
        nextFocus = field.debugDescription
    }

    func getNextFocus() -> String? {
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

    func error(for field: PartialKeyPath<F>) -> Error? {
        errors[field]
    }
}

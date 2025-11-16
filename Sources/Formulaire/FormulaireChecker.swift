//
//  FormulaireMetadata.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 22/07/2025.
//

import SwiftUI

typealias FormFocus = FocusState<String?>.Binding

@Observable
public final class FormulaireChecker<Field: FieldsProtocol> {
//    public func nested<N: Formulaire>(for field: FieldPath<F, N>) -> FormulaireChecker<N> {
//        let concreteField = F.__fields[keyPath: field]
//        return FormulaireChecker<N>()
//    }

    private var errors: [Field.Cases: Error] = [:]

    @ObservationIgnored
    var nextFocus: Field.Cases?

    public func addError(_ error: Error, field: Field.Cases) {
        errors[field] = error
    }

    public func focus(on field: Field.Cases) {
        nextFocus = field
    }

    func getNextFocus() -> Field.Cases? {
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

    func error(for field: Field.Cases) -> Error? {
        errors[field]
    }
}

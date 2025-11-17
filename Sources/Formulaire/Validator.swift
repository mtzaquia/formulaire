//
//  Validator.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 16/11/2025.
//

import Foundation

@Observable
public final class Validator<F: Formulaire> {
    @ObservationIgnored
    var parent: String?

    var errors: [String: Error] = [:]

    public init() {}

    func addError(_ error: Error, for key: String) {
        let key = [parent, key].compactMap(\.self).joined(separator: ".")
        errors[key] = error
    }

    func clearAllErrors() {
        errors = [:]
    }

    func hasErrors() -> Bool {
        !errors.values.compactMap(\.self).isEmpty
    }
}

public extension Formulaire {
    func addError<V>(_ error: Error, for field: FieldPath<Self, V>) {
        let concreteField = Self.__fields[keyPath: field]
        __validator.addError(error, for: concreteField.label)
    }

    func validate<F: Formulaire>(_ nested: FieldPath<Self, F>) {
        let concreteField = Self.__fields[keyPath: nested]
        let target = self[keyPath: concreteField.keyPath]

        target.__validator.parent = concreteField.label
        target.validate()

        __validator.errors.merge(target.__validator.errors, uniquingKeysWith: { _, new in new })
    }
}

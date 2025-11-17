//
//  Validator.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 16/11/2025.
//

import Foundation

/// An entity that validates ``Formulaire`` subjects.
@Observable
public final class Validator<F: Formulaire> {
    @ObservationIgnored
    var parent: String?

    var errors: [String: Error] = [:]

    /// **[Internal use]** You do not instantiate this type directly.
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
    /// Attaches an error to a given field of this subject in this validation pass.
    ///
    /// Only one error can be applied to a field. Applying an error to a field that already has errors overrides the previous value.
    ///
    /// - Parameters:
    ///   - error: The error to be added.
    ///   - field: The field in which the error is attached.
    func addError<V>(_ error: Error, for field: FieldPath<Self, V>) {
        let concreteField = Self.__fields[keyPath: field]
        __validator.addError(error, for: concreteField.label)
    }

    /// Validates a nested ``Formulaire`` type while validating your current subject.
    ///
    /// - Note: You can also validate nested subjects using ``addError(_:for:)``, using nested key paths. The benefit of this function is that
    /// validation logic can be reused across subjects.
    ///
    /// - Parameter nested: The field of the nested subject that is to be validated.
    func validate<F: Formulaire>(_ nested: FieldPath<Self, F>) {
        let concreteField = Self.__fields[keyPath: nested]
        let target = self[keyPath: concreteField.keyPath]

        target.__validator.parent = concreteField.label
        target.validate()

        __validator.errors.merge(target.__validator.errors, uniquingKeysWith: { _, new in new })
    }
}

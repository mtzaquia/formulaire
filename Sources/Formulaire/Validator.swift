//
//  Copyright (c) 2025 @mtzaquia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
        __validator._validateNested(target, parent: concreteField.label)
    }

    /// Validates a nested ``Formulaire`` type while validating your current subject.
    ///
    /// - Note: You can also validate nested subjects using ``addError(_:for:)``, using nested key paths. The benefit of this function is that
    /// validation logic can be reused across subjects.
    ///
    /// - Parameter nested: The field of the nested subject that is to be validated.
    func validate<F: Formulaire>(_ nested: FieldPath<Self, Optional<F>>) {
        let concreteField = Self.__fields[keyPath: nested]
        guard let target = self[keyPath: concreteField.keyPath] else { return }
        __validator._validateNested(target, parent: concreteField.label)
    }
}

private extension Validator {
    func _validateNested<N: Formulaire>(_ nested: N, parent: String) {
        nested.__validator.clearAllErrors()
        nested.__validator.parent = parent

        nested.validate()

        errors.merge(nested.__validator.errors, uniquingKeysWith: { _, new in new })
    }
}

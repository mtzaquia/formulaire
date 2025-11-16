//
//  Validator.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 16/11/2025.
//

import Foundation

@Observable
public final class Validator<F: Formulaire> {
    var errors: [String: Error] = [:]

    public init() {}

    func clearAllErrors() {
        errors = [:]
    }

    func hasErrors() -> Bool {
        !errors.values.compactMap(\.self).isEmpty
    }
}

//
//  FormulaireField.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 16/11/2025.
//

import Foundation

public typealias FieldPath<F: Formulaire, V> = KeyPath<F.Fields, FormulaireField<F, V>>

@dynamicMemberLookup
public struct FormulaireField<F: Formulaire, V>: Hashable {
    let label: String
    let keyPath: WritableKeyPath<F, V>

    /// **[Internal use]** You do not instantiate this type directly.
    public init(label: String, keyPath: WritableKeyPath<F, V>) {
        self.label = label
        self.keyPath = keyPath
    }

    public subscript<T>(dynamicMember keyPath: FieldPath<V, T>) -> FormulaireField<F, T> where V: Formulaire {
        let nested = V.__fields[keyPath: keyPath]
        return FormulaireField<F, T>(
            label: [self.label, nested.label].joined(separator: "."),
            keyPath: self.keyPath.appending(path: nested.keyPath)
        )
    }
}


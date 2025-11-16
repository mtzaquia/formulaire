//
//  FormulaireField.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 16/11/2025.
//

import Foundation

@dynamicMemberLookup
public struct FormulaireField<F: Formulaire, V>: Hashable {
    public let label: F.Fields.Cases
    public let keyPath: WritableKeyPath<F, V>

    public init(label: F.Fields.Cases, keyPath: WritableKeyPath<F, V>) {
        self.label = label
        self.keyPath = keyPath
    }

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<V, T>) -> FormulaireField<F, T> {
        FormulaireField<F, T>(
            label: self.label,
            keyPath: self.keyPath.appending(path: keyPath)
        )
    }
}

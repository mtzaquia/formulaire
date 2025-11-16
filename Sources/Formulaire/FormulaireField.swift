//
//  FormulaireField.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 16/11/2025.
//

import Foundation

@dynamicMemberLookup
public struct FormulaireField<F: Formulaire, V>: Hashable {
    public let label: String
    public let keyPath: WritableKeyPath<F, V>

    public init(label: String, keyPath: WritableKeyPath<F, V>) {
        self.label = label
        self.keyPath = keyPath
    }

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<V, T>) -> FormulaireField<F, T> {
        FormulaireField<F, T>(
            label: Self.resolveNestedLabel(parentLabel: self.label, in: F.__fields, via: keyPath) ?? (self.label + "." + String(describing: keyPath)),
            keyPath: self.keyPath.appending(path: keyPath)
        )
    }
    
    private static func resolveNestedLabel<T>(parentLabel: String, in fields: any Any, via keyPath: WritableKeyPath<V, T>) -> String? {
        // Try to downcast fields to a type that exposes properties matching V
        // We expect generated Fields to expose computed properties for each field name.
        // Use Mirror to discover a matching property whose keyPath matches the provided keyPath when appended.
        let mirror = Mirror(reflecting: fields)
        for child in mirror.children {
            guard let field = child.value as? FormulaireField<F, T> else { continue }
            // We cannot compare key paths directly without a value, but we trust the generated __fields to return correct labels per property.
            // If label matches the last segment of the key path description, use it.
            let lastSegment = String(describing: keyPath)
            if field.label == lastSegment || field.label.hasSuffix(lastSegment) {
                return parentLabel + "." + field.label
            }
        }
        return nil
    }
}


//
//  FormulaireMetadata.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 22/07/2025.
//

import SwiftUI

typealias FormFocus = FocusState<String?>.Binding

struct FormulaireMetadataReader<F: Formulaire, C: View>: View {
    @Environment(FormulaireMetadata<F>.self) private var formulaire
    @Environment(\.formFocus) private var formFocus

    let content: (FormulaireMetadata<F>, FormFocus) -> C

    var body: some View {
        content(formulaire, formFocus!)
    }

    init(@ViewBuilder _ content: @escaping (FormulaireMetadata<F>, FormFocus) -> C) {
        self.content = content
    }
}

@Observable
final class FormulaireMetadata<F: Formulaire> {
    var errorBuilder: ErrorBuilder<F> = ErrorBuilder<F>()
}

@Observable
public final class ErrorBuilder<F: Formulaire> {
    private var errors: [AnyKeyPath: Error] = [:]

    @ObservationIgnored
    var nextFocus: String?

    public func addError<V>(_ error: Error, keyPath: KeyPath<F, V>) {
        errors[keyPath] = error
    }

    public func focus<V>(on keyPath: KeyPath<F, V>) {
        nextFocus = keyPath.debugDescription
    }

    func clearAllErrors() {
        errors = [:]
    }

    func hasErrors() -> Bool {
        !errors.values.compactMap(\.self).isEmpty
    }

    func error<V>(for keyPath: KeyPath<F, V>) -> Error? {
        errors[keyPath]
    }
}

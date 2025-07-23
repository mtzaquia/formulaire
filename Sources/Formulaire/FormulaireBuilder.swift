//
//  FormulaireBuilder.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 22/07/2025.
//

import Foundation
import SwiftUI

@MainActor
public struct FormulaireBuilder<F: Formulaire> {
    @Binding var formulaire: F

    public func submitButton(_ label: String, onSubmit: @escaping () -> Void) -> some View {
        FormulaireMetadataReader<F, _> { metadata, focus in
            Button(label) {
                metadata.errorBuilder.clearAllErrors()

                formulaire.validate(errorBuilder: metadata.errorBuilder)

                if !metadata.errorBuilder.hasErrors() {
                    onSubmit()
                } else {
                    focus.wrappedValue = metadata.errorBuilder.nextFocus
                    metadata.errorBuilder.nextFocus = nil
                }
            }
            .bold()
        }
    }
}

// MARK: - Views

public extension FormulaireBuilder {
    func textField(for keyPath: WritableKeyPath<F, String>, label: String) -> some View {
        FormulaireMetadataReader<F, _> { metadata, focus in
            VStack(alignment: .leading) {
                Text(label)
                TextField(label, text: $formulaire[dynamicMember: keyPath])
                    .focused(focus, equals: keyPath.debugDescription)

                ErrorText(error: metadata.errorBuilder.error(for: keyPath))
            }
            .onAppear {
                print(keyPath.debugDescription)
            }
        }
    }

    func toggle(for keyPath: WritableKeyPath<F, Bool>, label: String) -> some View {
        FormulaireMetadataReader { metadata, _ in
            VStack(alignment: .leading) {
                Toggle(label, isOn: $formulaire[dynamicMember: keyPath])

                ErrorText(error: metadata.errorBuilder.error(for: keyPath))
            }
        }
    }

    func stepper(
        for keyPath: WritableKeyPath<F, Int>,
        label: String,
        step: Int = 1,
        range: ClosedRange<Int>? = nil
    ) -> some View {
        FormulaireMetadataReader { metadata, _ in
            VStack(alignment: .leading) {
                Stepper(
                    value: $formulaire[dynamicMember: keyPath].onChange {
                        guard let range else { return }
                        formulaire[keyPath: keyPath] = min(max($0, range.lowerBound), range.upperBound)
                    },
                    step: step
                ) {
                    Text(label)
                    Text(formulaire[keyPath: keyPath].formatted())
                        .monospaced()
                }

                ErrorText(error: metadata.errorBuilder.error(for: keyPath))
            }
        }
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

struct ErrorText: View {
    let error: Error?

    var body: some View {
        if let error = error {
            Text(error.localizedDescription)
                .font(.caption.weight(.medium))
                .foregroundStyle(.red)
        }
    }
}

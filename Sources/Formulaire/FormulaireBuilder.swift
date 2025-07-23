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
    @Binding var checker: FormulaireChecker<F>
    @FocusState.Binding var focus: String?
}

// MARK: - Views

public extension FormulaireBuilder {
    func submitButton(_ label: String, onSubmit: @escaping () -> Void) -> some View {
        Button(label) {
            checker.clearAllErrors()

            formulaire.validate(checker: checker)

            if !checker.hasErrors() {
                onSubmit()
            } else {
                focus = checker.getNextFocus()
            }
        }
        .bold()
    }

    func textField(for field: WritableKeyPath<F, String>, label: String) -> some View {
        VStack(alignment: .leading) {
            Text(label)
            TextField(label, text: $formulaire[dynamicMember: field])
                .focused($focus, equals: field.debugDescription)

            ErrorText(error: checker.error(for: field))
        }
    }

    func toggle(for field: WritableKeyPath<F, Bool>, label: String) -> some View {
        VStack(alignment: .leading) {
            Toggle(label, isOn: $formulaire[dynamicMember: field])

            ErrorText(error: checker.error(for: field))
        }
    }

    func stepper(
        for field: WritableKeyPath<F, Int>,
        label: String,
        step: Int = 1,
        range: ClosedRange<Int>? = nil
    ) -> some View {
        VStack(alignment: .leading) {
            Stepper(
                value: $formulaire[dynamicMember: field].onChange {
                    guard let range else { return }
                    formulaire[keyPath: field] = min(max($0, range.lowerBound), range.upperBound)
                },
                step: step
            ) {
                Text(label)
                Text(formulaire[keyPath: field].formatted())
                    .monospaced()
            }

            ErrorText(error: checker.error(for: field))
        }
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

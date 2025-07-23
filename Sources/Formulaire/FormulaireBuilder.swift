//
//  FormulaireBuilder.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 22/07/2025.
//

import Foundation
import SwiftUI

//public final class FormulaireTracker: ObservableObject {
//    var existingFields: Set<String> = Set<String>()
//}

@MainActor
public struct FormulaireBuilder<F: Formulaire> {
    @Binding var formulaire: F
    @Binding var checker: FormulaireChecker<F>
    @FocusState.Binding var focus: String?

//    let formulaireTracker: FormulaireTracker
}

@MainActor
public struct ControlBuilder<F: Formulaire, V> {
    public var binding: Binding<V>
    @FocusState.Binding public var focus: String?
    public let error: Error?
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
//        formulaireTracker.existingFields.insert(field.debugDescription)
        return VStack(alignment: .leading) {
            Text(label)
            TextField(label, text: $formulaire[dynamicMember: field])
                .focused($focus, equals: field.debugDescription)

            ErrorText(error: checker.error(for: field))
        }
    }

    func toggle(for field: WritableKeyPath<F, Bool>, label: String) -> some View {
//        formulaireTracker.existingFields.insert(field.debugDescription)
        return VStack(alignment: .leading) {
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
//        formulaireTracker.existingFields.insert(field.debugDescription)
        return VStack(alignment: .leading) {
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

    func customControl<V, C: View>(
        for field: WritableKeyPath<F, V>,
        @ViewBuilder controlBuilder: (ControlBuilder<F, V>) -> C
    ) -> some View {
//        formulaireTracker.existingFields.insert(field.debugDescription)
        return controlBuilder(
            ControlBuilder(
                binding: $formulaire[dynamicMember: field],
                focus: $focus,
                error: checker.error(for: field)
            )
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

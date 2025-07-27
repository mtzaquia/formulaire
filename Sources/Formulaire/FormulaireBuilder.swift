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
    @FocusState.Binding var focus: F.Fields.Cases?
}

@MainActor
public struct ControlBuilder<F: Formulaire, V> {
    public var binding: Binding<V>
    @FocusState.Binding public var focus: F.Fields.Cases?
    public let error: Error?
}

// MARK: - Views

public typealias FieldPath<F: Formulaire, V> = KeyPath<F.Fields, FormulaireField<F, V>>

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

    func textField(for field: FieldPath<F, String>, label: String) -> some View {
        let concreteField = formulaire.__fields[keyPath: field]
        let error = checker.error(for: concreteField.label)
        return VStack(alignment: .leading) {
            Text(label)
                .foregroundStyle(
                    error != nil ? AnyShapeStyle(.red) : (
                        focus == concreteField.label ? AnyShapeStyle(.tint) : AnyShapeStyle(.secondary)
                    )
                )
                .font(.caption.bold())
                .textCase(.uppercase)
            TextField(label, text: $formulaire[dynamicMember: concreteField.keyPath], prompt: Text("Enter \(label)"))
                .focused($focus, equals: concreteField.label)

            ErrorText(error: error)
        }
        .preference(key: PresencePreferenceKey.self, value: [AnyHashable(concreteField.label)])
    }

    func toggle(for field: FieldPath<F, Bool>, label: String) -> some View {
        let concreteField = formulaire.__fields[keyPath: field]
        let error = checker.error(for: concreteField.label)

        return VStack(alignment: .leading) {
            Toggle(isOn: $formulaire[dynamicMember: concreteField.keyPath]) {
                Text(label)
                    .foregroundStyle(error != nil ? AnyShapeStyle(.red) : AnyShapeStyle(.primary))
            }

            ErrorText(error: error)
        }
    }

    func stepper(
        for field: FieldPath<F, Int>,
        label: String,
        step: Int = 1,
        range: ClosedRange<Int>? = nil
    ) -> some View {
        let concreteField = formulaire.__fields[keyPath: field]

        return VStack(alignment: .leading) {
            Stepper(
                value: $formulaire[dynamicMember: concreteField.keyPath].onChange {
                    guard let range else { return }
                    formulaire[keyPath: concreteField.keyPath] = min(max($0, range.lowerBound), range.upperBound)
                },
                step: step
            ) {
                Text(label)
                Text(formulaire[keyPath: concreteField.keyPath].formatted())
                    .monospaced()
            }

            ErrorText(error: checker.error(for: concreteField.label))
        }
    }

    func customControl<V, C: View>(
        for field: FieldPath<F, V>,
        focusable: Bool = false,
        @ViewBuilder controlBuilder: (ControlBuilder<F, V>) -> C
    ) -> some View {
        let concreteField = formulaire.__fields[keyPath: field]

        return controlBuilder(
            ControlBuilder(
                binding: $formulaire[dynamicMember: concreteField.keyPath],
                focus: $focus,
                error: checker.error(for: concreteField.label)
            )
        )
        .preference(key: PresencePreferenceKey.self, value: focusable ? [AnyHashable(concreteField.label)] : [])
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

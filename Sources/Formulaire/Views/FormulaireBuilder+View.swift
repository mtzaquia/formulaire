//
//  FormulaireBuilder+View.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 17/11/2025.
//

import SwiftUI

public extension FormulaireBuilder {
    func control<V, Content: View>(
        for field: FieldPath<F, V>,
        focusable: Bool,
        content: (ControlBuilder<F, V>) -> Content
    ) -> some View {
        let concreteField = F.__fields[keyPath: field]

        if focusable {
            renderedFields.value.append(concreteField.label)
        }

        return content(
            ControlBuilder(
                label: concreteField.label,
                value: $formulaire[dynamicMember: concreteField.keyPath],
                focus: $focus,
                error: formulaire.__validator.errors[concreteField.label]
            )
        )
        .id(concreteField.label)
    }

    func submitButton(_ label: String, onSubmit: @escaping () -> Void) -> some View {
        Button(label) {
            formulaire.__validator.clearAllErrors()

            formulaire.validate()

            if !formulaire.__validator.hasErrors() {
                onSubmit()
            }
        }
        .bold()
    }

    func textField(for field: FieldPath<F, String>, label: String) -> some View {
        control(for: field, focusable: true) { builder in
            VStack(alignment: .leading) {
                Text(label)
                    .foregroundStyle(
                        builder.error != nil ? AnyShapeStyle(.red) : (
                            builder.isFocused ? AnyShapeStyle(.tint) : AnyShapeStyle(.secondary)
                        )
                    )
                    .font(.caption.bold())
                    .textCase(.uppercase)
                TextField(label, text: builder.$value, prompt: Text("Enter \(label)"))
                    .focused(builder.$focus, equals: builder.label)

                ErrorText(error: builder.error)
            }
        }
    }

    func toggle(for field: FieldPath<F, Bool>, label: String) -> some View {
        control(for: field, focusable: false) { builder in
            VStack(alignment: .leading) {
                Toggle(isOn: builder.$value) {
                    Text(label)
                        .foregroundStyle(builder.error != nil ? AnyShapeStyle(.red) : AnyShapeStyle(.primary))
                }

                ErrorText(error: builder.error)
            }
        }
    }

    func stepper(
        for field: FieldPath<F, Int>,
        label: String,
        step: Int = 1,
        range: ClosedRange<Int>? = nil
    ) -> some View {
        control(for: field, focusable: false) { builder in
            VStack(alignment: .leading) {
                Stepper(
                    value: builder.$value,
                    step: step
                ) {
                    Text(label)
                    Text(builder.value.formatted())
                        .monospaced()
                }

                ErrorText(error: builder.error)
            }
            .onChange(of: builder.value) { _, new in
                guard let range else { return }
                builder.value = min(max(new, range.lowerBound), range.upperBound)
            }
        }
    }
}


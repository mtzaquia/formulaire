//
//  Copyright (c) 2025 @mtzaquia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
            if !validate() {
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


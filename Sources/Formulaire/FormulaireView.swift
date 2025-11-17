//
//  FormulaireView.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 22/07/2025.
//

import Collections
import SwiftUI

final class Wrapper<T> {
    var value: T

    init(value: T) {
        self.value = value
    }
}

extension EnvironmentValues {
    @Entry var renderedFields: Wrapper<[String]>?
}

public struct FormulaireView<F: Formulaire, C: View>: View {
    @Binding var subject: F
    let builder: (FormulaireBuilder<F>) -> C
    @FocusState private var focus: String?

    private let renderedFields: Wrapper<[String]> = .init(value: [])

    public var body: some View {
        ScrollViewReader { proxy in
            Form {
                let _ = renderedFields.value.removeAll()

                builder(
                    FormulaireBuilder<F>(
                        formulaire: $subject,
                        focus: $focus,
                        renderedFields: renderedFields
                    )
                )
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Group {
                        Button(
                            action: { [fields = renderedFields.value] in
                                guard let currentIndex = focus.flatMap({ fields.firstIndex(of: $0) })
                                else { return }

                                if currentIndex - 1 >= 0 {
                                    let previous = fields[currentIndex - 1]
                                    withAnimation(.snappy) {
                                        proxy.scrollTo(previous)
                                    }

                                    focus = previous
                                }
                            },
                            label: {
                                Label("Previous", systemImage: "chevron.up")
                            }
                        )
                        .disabled(focus.flatMap({ renderedFields.value.firstIndex(of: $0) }) == 0)

                        Button(
                            action: { [fields = renderedFields.value] in
                                guard let currentIndex = focus.flatMap({ fields.firstIndex(of: $0) })
                                else { return }

                                if currentIndex + 1 < fields.count {
                                    let next = fields[currentIndex + 1]
                                    withAnimation(.snappy) {
                                        proxy.scrollTo(next)
                                    }

                                    focus = next
                                }
                            },
                            label: {
                                Label("Next", systemImage: "chevron.down")
                            }
                        )
                        .disabled(
                            focus.flatMap({ renderedFields.value.firstIndex(of: $0) }) == renderedFields.value.count - 1
                        )

                        Color.clear.frame(maxWidth: .infinity)

                        Button(
                            action: { focus = nil },
                            label: {
                                Label("Done", systemImage: "checkmark")
                                    .labelStyle(.iconOnly)
                            }
                        )
                        .bold()
                    }
                }
            }
        }
    }

    public init(
        editing subject: Binding<F>,
        @ViewBuilder builder: @escaping (FormulaireBuilder<F>) -> C
    ) {
        self._subject = subject
        self.builder = builder
    }
}

//
//  FormulaireView.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 22/07/2025.
//

import Collections
import SwiftUI

public struct FormulaireView<F: Formulaire, C: View>: View {
    @Binding var object: F
    let builder: (FormulaireBuilder<F>) -> C

    @State private var checker: FormulaireChecker<F> = FormulaireChecker<F>()
    @State private var fields: OrderedSet<F.Fields.Cases> = []
    @FocusState private var focus: F.Fields.Cases?

    public var body: some View {
        ScrollViewReader { proxy in
            Form {
                builder(
                    FormulaireBuilder<F>(
                        formulaire: $object,
                        checker: $checker,
                        focus: $focus
                    )
                )
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button(
                        action: {
                            let currentIndex = focus.flatMap(fields.firstIndex(of:))
                            guard let currentIndex, currentIndex - 1 >= 0 else { return }

                            let fieldToFocus = fields[currentIndex - 1]
                            proxy.scrollTo(fieldToFocus, anchor: .top)

                            DispatchQueue.main.async {
                                focus = fieldToFocus
                            }
                        },
                        label: {
                            Label("Previous", systemImage: "chevron.up")
                        }
                    )

                    Button(
                        action: {
                            guard let currentIndex = focus.flatMap(fields.firstIndex(of:)),
                                  currentIndex + 1 < fields.count
                            else { return }

                            let fieldToFocus = fields[currentIndex + 1]
                            proxy.scrollTo(fieldToFocus, anchor: .bottom)

                            DispatchQueue.main.async {
                                focus = fieldToFocus
                            }
                        },
                        label: {
                            Label("Next", systemImage: "chevron.down")
                        }
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
        .onPreferenceChange(PresencePreferenceKey.self) {
            let casted = $0?.compactMap { $0.base as? F.Fields.Cases } ?? []
            fields = OrderedSet(casted)
            print(fields)
        }
    }

    public init(
        editing object: Binding<F>,
        @ViewBuilder builder: @escaping (FormulaireBuilder<F>) -> C
    ) {
        self._object = object
        self.builder = builder
    }
}

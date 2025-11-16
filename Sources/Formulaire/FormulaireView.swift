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

    @State private var checker = FormulaireChecker<F.Fields>()
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
                    Group {
                        Button(
                            action: {

                            },
                            label: {
                                Label("Previous", systemImage: "chevron.up")
                            }
                        )

                        Button(
                            action: {

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

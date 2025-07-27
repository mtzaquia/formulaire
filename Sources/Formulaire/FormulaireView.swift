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
        Form {
            builder(
                FormulaireBuilder<F>(
                    formulaire: $object,
                    checker: $checker,
                    focus: $focus // ,
//                    formulaireTracker: tracker
                )
            )
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                // TODO: Fix navigation. We need to keep track of which keypaths were added to the form. We can
                // do that with the FormulaireBuilder methods, manipulating a binding from the FormulaireView.
                KeyboardNavigationView(
                    onNext: {
                        guard let currentIndex = focus.flatMap(fields.firstIndex(of:)),
                              currentIndex + 1 < fields.count
                        else { return }

                        focus = fields[currentIndex + 1]
                    },
                    onPrevious: {
                        guard let currentIndex = focus.flatMap(fields.firstIndex(of:)),
                              currentIndex - 1 >= 0
                        else { return }

                        focus = fields[currentIndex - 1]
                    },
                    onDone: { focus = nil }
                )
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

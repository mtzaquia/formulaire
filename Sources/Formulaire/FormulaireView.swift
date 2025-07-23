//
//  FormulaireView.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 22/07/2025.
//

import SwiftUI

public struct FormulaireView<F: Formulaire, C: View>: View {
    @Binding var object: F
    let builder: (FormulaireBuilder<F>) -> C

    @State private var checker: FormulaireChecker<F> = FormulaireChecker<F>()
    @FocusState private var focus: String?

    public var body: some View {
        Form {
            builder(FormulaireBuilder<F>(formulaire: $object, checker: $checker, focus: $focus))
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                // TODO: Fix navigation. We need to keep track of which keypaths were added to the form. We can
                // do that with the FormulaireBuilder methods, manipulating a binding from the FormulaireView.
                KeyboardNavigationView(
                    onNext: {
                        let fields = F.__formulaireFields
                        let length = fields.count
                        guard let currentIndex = fields.firstIndex(where: { $0.keyPath.debugDescription == focus }) else {
                            return
                        }
                        focus = fields[max(currentIndex + 1, length - 1)].keyPath.debugDescription
                    },
                    onPrevious: {
                        let fields = F.__formulaireFields
                        guard let currentIndex = fields.firstIndex(where: { $0.keyPath.debugDescription == focus }) else {
                            return
                        }
                        focus = fields[min(currentIndex - 1, 0)].keyPath.debugDescription
                    },
                    onDone: { focus = nil }
                )
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

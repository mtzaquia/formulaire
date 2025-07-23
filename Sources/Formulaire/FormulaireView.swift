//
//  FormulaireView.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 22/07/2025.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var formFocus: FormFocus?
}

public struct FormulaireView<F: Formulaire, C: View>: View {
    @Binding var object: F
    let builder: (FormulaireBuilder<F>) -> C

    @FocusState private var formFocus: String?

    public var body: some View {
        Form {
            builder(FormulaireBuilder(formulaire: $object))
                .environment(FormulaireMetadata<F>())
                .environment(\.formFocus, $formFocus)
        }
        .onAppear {
            
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Button {

                    } label: {
                        Label("Previous", systemImage: "chevron.up")
                    }

                    Button {

                    } label: {
                        Label("Next", systemImage: "chevron.down")
                    }

                    Spacer()

                    Button("Done") {
                        formFocus = nil
                    }
                    .bold()
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

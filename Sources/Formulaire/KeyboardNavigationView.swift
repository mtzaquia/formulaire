//
//  KeyboardNavigationView.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 23/07/2025.
//

import SwiftUI

struct KeyboardNavigationView: View {
    let onNext: () -> Void
    let onPrevious: () -> Void
    let onDone: () -> Void

    var body: some View {
        HStack {
            Button(action: onPrevious) {
                Label("Previous", systemImage: "chevron.up")
            }

            Button(action: onNext) {
                Label("Next", systemImage: "chevron.down")
            }

            Spacer()

            Button("Done", action: onDone)
                .bold()
        }
    }
}

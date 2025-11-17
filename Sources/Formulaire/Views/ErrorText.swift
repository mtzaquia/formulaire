//
//  ErrorText.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 17/11/2025.
//

import SwiftUI

struct ErrorText: View {
    let error: Error?

    var body: some View {
        if let error {
            Text(error.localizedDescription)
                .font(.caption.weight(.medium))
                .foregroundStyle(.red)
        }
    }
}

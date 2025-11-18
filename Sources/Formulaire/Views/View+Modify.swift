//
//  View+Modify.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 17/11/2025.
//

import SwiftUI

extension View {
    func modify<Result: View>(@ViewBuilder _ builder: (Self) -> Result) -> some View {
        builder(self)
    }
}

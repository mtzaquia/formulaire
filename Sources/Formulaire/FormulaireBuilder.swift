//
//  FormulaireBuilder.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 22/07/2025.
//

import Foundation
import SwiftUI

public struct FormulaireBuilder<F: Formulaire> {
    @Binding var formulaire: F
    @FocusState.Binding var focus: String?
    let renderedFields: Wrapper<[String]>
}

public struct ControlBuilder<F: Formulaire, V> {
    public var label: String
    @Binding public var value: V
    @FocusState.Binding public var focus: String?
    public var error: Error?

    var isFocused: Bool {
        focus == label
    }
}

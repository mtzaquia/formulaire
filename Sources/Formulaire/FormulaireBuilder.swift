//
//  Copyright (c) 2025 @mtzaquia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
@_exported import IdentifiedCollections
import SwiftUI

public struct FormulaireBuilder<F: Formulaire> {
    @Binding var formulaire: F
    @FocusState.Binding var focus: String?
    let renderedFields: Wrapper<[String]>
    let fieldPrefix: String?
    let getErrors: () -> [String: Error]

    /// Validates the entire form, applying errors as per the individual ``Formulaire/validate()`` methods.
    /// - Returns: `true` if there are no errors, `false` if there are errors.
    public func validate() -> Bool {
        formulaire.__validator.clearAllErrors()
        formulaire.validate()
        return !formulaire.__validator.hasErrors()
    }

    public func scope<S: Formulaire & Identifiable>(_ field: FieldPath<F, IdentifiedArrayOf<S>>, for child: S) -> FormulaireBuilder<S> {
        let concreteField = F.__fields[keyPath: field]

        var list = concreteField.get(formulaire)

        let scopedBuilder = FormulaireBuilder<S>(
            formulaire: Binding(
                get: { child },
                set: { list[id: child.id] = $0 }
            ),
            focus: $focus,
            renderedFields: renderedFields,
            fieldPrefix: concreteField.label + "[\(child.id.hashValue)]",
            getErrors: { formulaire.__validator.errors }
        )

        return scopedBuilder
    }
}



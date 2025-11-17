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
import SwiftUI

public struct FormulaireBuilder<F: Formulaire> {
    @Binding var formulaire: F
    @FocusState.Binding var focus: String?
    let renderedFields: Wrapper<[String]>

    /// Validates the entire form, applying errors as per the individual ``Formulaire/validate()`` methods.
    /// - Returns: `true` if there are no errors, `false` if there are errors.
    public func validate() -> Bool {
        formulaire.__validator.clearAllErrors()
        formulaire.validate()
        return !formulaire.__validator.hasErrors()
    }
}

public struct ControlBuilder<F: Formulaire, V> {
    public var label: String
    @Binding public var value: V
    @FocusState.Binding public var focus: String?
    public var error: Error?

    public var isFocused: Bool {
        focus == label
    }
}

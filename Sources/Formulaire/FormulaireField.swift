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

public typealias FieldPath<F: Formulaire, V> = KeyPath<F.Fields, FormulaireField<F, V>>

@dynamicMemberLookup
public struct FormulaireField<F: Formulaire, V>: Hashable {
    let label: String
    let keyPath: WritableKeyPath<F, V>

    /// **[Internal use]** You do not instantiate this type directly.
    public init(label: String, keyPath: WritableKeyPath<F, V>) {
        self.label = label
        self.keyPath = keyPath
    }

    public subscript<T>(dynamicMember keyPath: FieldPath<V, T>) -> FormulaireField<F, T> where V: Formulaire {
        let nested = V.__fields[keyPath: keyPath]
        return FormulaireField<F, T>(
            label: [self.label, nested.label].joined(separator: "."),
            keyPath: self.keyPath.appending(path: nested.keyPath)
        )
    }
}

